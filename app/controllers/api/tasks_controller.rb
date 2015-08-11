class Api::TasksController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        render json: current_user.tasks
      end
    end
  end
end
