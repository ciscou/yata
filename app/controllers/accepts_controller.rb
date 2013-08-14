class AcceptsController < ApplicationController
  def show
    original_task = Task.find(params[:share_id]) # TODO: this should find by guid
    @task = current_user.tasks.new original_task.attributes.slice("name", "due_at", "reminder_send_before_due_at")
  end
end
