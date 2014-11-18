class TasksController < ApplicationController
  before_filter :pick_show_parameter, only: :index
  before_filter :load_category, only: :index

  def index
    @tasks = current_user.tasks.send(@show)
    if @category
      @tasks = @tasks.where(category_id: @category.id)
    elsif params[:category_id] == ''
      @tasks = @tasks.where(category_id: nil)
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
    @task.done = true if flash[:just_done]
  end

  def new
    @task = current_user.tasks.new
    @task.sub_tasks.build
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @task.sub_tasks.build
  end

  def create
    @task = current_user.tasks.new(task_attributes)

    if @task.save
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
    @task = current_user.tasks.find(params[:id])
    @task.destroy

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
    current_user.tasks.done.destroy_all

    redirect_to tasks_url(show: 'done'), notice: "Done tasks were successfully cleared"
  end

  private

  def pick_show_parameter
    @show  = params[:show] || session[:show]
    @show  = "todo" unless @show.in? Task::SCOPES
    session[:show] = @show
  end

  def load_category
    if params[:category_id].present?
      @category = current_user.categories.find(params[:category_id])
    end
  end

  def task_attributes
    params.require(:task).permit!
  end
end
