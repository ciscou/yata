class SharesController < ApplicationController
  def create
    @task = current_user.tasks.find(params[:task_id])
    @task.ensure_token!
    TaskMailer.share(@task, current_user.email, params[:email]).deliver

    redirect_to @task, notice: "Your task was shared successfully!"
  end
end
