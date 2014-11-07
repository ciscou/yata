class AcceptsController < ApplicationController
  def show
    original_task = Task.find_by_token!(params[:share_id])
    @task = original_task.build_accept_for(current_user)
  end
end
