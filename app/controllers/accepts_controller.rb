class AcceptsController < ApplicationController
  def show
    original_task = Task.find_by_token!(params[:share_id])
    @task = current_user.tasks.new original_task.attributes.slice("name", "due_at", "reminder_send_before_due_at", "url", "location", "description")
  end
end
