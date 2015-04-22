class TasksController < ApplicationController
  before_filter :pick_show_parameter, only: :index
  before_filter :load_category_name, only: [:index, :new]

  def index
    @tasks = current_user.tasks.send(@show)

    if @category_name == 'uncategorized'
      @tasks = @tasks.where(category_name: [nil, ''])
    elsif @category_name == 'all'
      # no-op
    elsif @category_name
      @tasks = @tasks.where(category_name: @category_name)
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
    @task.done = true if flash[:just_done]
  end

  def new
    @task = current_user.tasks.new
    @task.category_name = @category_name unless %w[all uncategorized].include?(@category_name)
    @task.sub_tasks.build
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @task.sub_tasks.build
  end

  def create
    @task = current_user.tasks.create(task_attributes)

    if @task.errors.empty?
      redirect_to @task, notice: 'Task was successfully created.'
    else
      flash.now.alert = "Oops, failed to create task"
      render action: "new"
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update_attributes(task_attributes)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      flash.now.alert = "Oops, failed to update task"
      render action: "edit"
    end
  end

  def destroy
    current_user.tasks.destroy(params[:id])

    redirect_to tasks_url, notice: "Task was successfully deleted"
  end

  def mark_as_done
    @task = current_user.tasks.find(params[:id])
    @task.mark_as_done!

    respond_to do |format|
      format.html {
        flash[:just_done] = true
        redirect_to @task, notice: "Task was succesfully marked as done"
      }
      format.js
    end
  end

  def unmark_as_done
    @task = current_user.tasks.find(params[:id])
    @task.unmark_as_done!

    respond_to do |format|
      format.html {
        redirect_to @task, notice: "Task was succesfully unmarked as done"
      }
      format.js { render :mark_as_done }
    end
  end

  def clear
    current_user.clear_done_tasks

    redirect_to tasks_url(show: 'done'), notice: "Done tasks were successfully cleared"
  end

  private

  def pick_show_parameter
    @show  = params[:show] || session[:show]
    @show  = "todo" unless @show.in? Task::SCOPES
    session[:show] = @show
  end

  def load_category_name
    @category_name = params[:category_name].presence || session[:category_name].presence || "all"
    session[:category_name] = @category_name
  end

  def task_attributes
    params.require(:task).permit!
  end
end
