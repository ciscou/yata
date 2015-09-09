class AcceptsController < ApplicationController
  before_filter :load_task
  before_filter :cannot_accept_twice

  def show
  end

  def create
    current_user.tasks << @task
    flash[:scroll_to] = @task.id
    redirect_to tasks_url if current_user.tasks.include?(@task)
  end

  private

  def load_task
    @task = Task.find_by_token!(params[:share_id])
  end

  def cannot_accept_twice
    flash[:scroll_to] = @task.id
    redirect_to tasks_url if current_user.tasks.include?(@task)
  end
end
