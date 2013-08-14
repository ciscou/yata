class RemindersController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if params[:key] == ENV['REMINDERS_KEY']
      Task.send_reminders
      render json: { success: true }
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end