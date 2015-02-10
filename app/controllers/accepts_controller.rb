class AcceptsController < ApplicationController
  def show
    @task = Task.find_by_token!(params[:share_id])
  end

  def create
    @task = Task.find_by_token!(params[:share_id])
    current_user.tasks << @task
    redirect_to @task, notice: "Shared task accepted successfully"
  end
end
