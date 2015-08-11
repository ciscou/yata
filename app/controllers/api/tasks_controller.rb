class Api::TasksController < ApplicationController
  def index
    render json: current_user.tasks
  end
end
