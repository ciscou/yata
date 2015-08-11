class Api::TasksController < ApplicationController
  respond_to :json

  def index
    respond_with @tasks = current_user.tasks
  end
end
