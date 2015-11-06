class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks.todo
  end

  def delayed
    @tasks = current_user.tasks.delayed
  end

  def today
    @tasks = current_user.tasks.today
  end

  def tomorrow
    @tasks = current_user.tasks.tomorrow
  end

  def later
    @tasks = current_user.tasks.later
  end

  def unscheduled
    @tasks = current_user.tasks.unscheduled
  end

  def done
    @tasks = current_user.tasks.done
  end

  def by_category
    @tasks = current_user.tasks.todo.where(category: params[:category])
  end

  def uncategorized
    @tasks = current_user.tasks.todo.uncategorized
  end

  def show
    @task = current_user.tasks.find(params[:id])
    @task.done = true if flash[:just_done]
  end

  def new
    @task = current_user.tasks.new
    @task.category = params[:category]
    @task.sub_tasks.build
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @task.sub_tasks.build
  end

  def create
    @task = current_user.tasks.create(task_attributes)
    @share_to = params[:share_to]

    if @task.errors.empty?
      if @share_to.present?
        @task.ensure_token!
        TaskMailer.share(@task, current_user.email, @share_to).deliver
      end

      flash[:scroll_to] = @task.id
      redirect_to tasks_url
    else
      flash.now.alert = "Oops, failed to create task"
      render action: "new"
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    @share_to = params[:share_to]

    if @task.update_attributes(task_attributes)
      if @share_to.present?
        @task.ensure_token!
        TaskMailer.share(@task, current_user.email, @share_to).deliver
      end

      flash[:scroll_to] = @task.id
      redirect_to tasks_url
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

    redirect_to done_tasks_url, notice: "Done tasks were successfully cleared"
  end

  private

  def task_attributes
    params.require(:task).permit!
  end
end
