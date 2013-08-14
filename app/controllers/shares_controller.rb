class SharesController < ApplicationController
  def create
    @task = current_user.tasks.find(params[:task_id])
    ShareEmail.share_email(@task, params[:email]).deliver

    redirect_to @task, notice: "Your task was shared successfully!"
  end
end
