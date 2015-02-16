class AcceptsController < ApplicationController
  before_filter :load_task
  before_filter :cannot_accept_twice

  def show
  end

  def create
    current_user.tasks << @task
    redirect_to @task, notice: "Shared task accepted successfully"
  end

  private

  def load_task
    @task = Task.find_by_token!(params[:share_id])
  end

  def cannot_accept_twice
    redirect_to @task, alert: "You've already accepted that task!" if current_user.tasks.include?(@task)
  end
end
