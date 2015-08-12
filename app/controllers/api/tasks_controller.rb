class Api::TasksController < ApplicationController
  def index
    render json: current_user.tasks
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
end
