class Api::TasksController < ApplicationController
  def index
    render json: current_user.tasks
  end

  def create
    task = current_user.tasks.create(task_attributes)

    if task.errors.empty?
      render json: task
    else
      render json: task, status: :unprocessable_entity
    end
  end

  def update
    task = current_user.tasks.find(params[:id])

    if task.update_attributes(task_attributes)
      render json: task
    else
      render json: task, status: :unprocessable_entity
    end
  end

  def mark_as_done
    task = current_user.tasks.find(params[:id])
    task.mark_as_done!
    render json: task
  end

  def unmark_as_done
    task = current_user.tasks.find(params[:id])
    task.unmark_as_done!
    render json: task
  end

  private

  def task_attributes
    params.require(:task).permit!
  end
end
