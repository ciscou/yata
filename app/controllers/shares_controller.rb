class SharesController < ApplicationController
  def create
    @task = current_user.tasks.find(params[:task_id])
    @task.ensure_token!
    TaskMailer.share(@task, current_user.email, params[:email]).deliver

    flash[:scroll_to] = @task.id
    redirect_to tasks_url
  end
end
