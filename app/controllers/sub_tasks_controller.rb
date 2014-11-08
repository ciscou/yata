class SubTasksController < ApplicationController
  def update
    @task = current_user.tasks.find(params[:task_id])
    @sub_task = @task.sub_tasks.find(params[:id])
    @sub_task.toggle!(:done)

    respond_to do |format|
      format.html { redirect_to @task }
      format.js
    end
  end
end
