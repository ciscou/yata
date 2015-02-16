class RemindersController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if params[:key].present? && params[:key] == ENV['REMINDERS_KEY']
      sent = Task.send_reminders
      render json: { success: true, sent: sent }
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end
