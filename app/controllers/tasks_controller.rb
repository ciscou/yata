class TasksController < ApplicationController
  before_filter :pick_show_parameter, :only => :index

  respond_to :html, :json

  def index
    @tasks = current_user.tasks.send(@show)
    respond_with @tasks
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = current_user.tasks.new
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def create
    @task = current_user.tasks.new(params[:task])

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      flash.now.alert = "Oops, failed to create task"
      render action: "new"
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update_attributes(params[:task])
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      flash.now.alert = "Oops, failed to update task"
      render action: "edit"
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.toggle_done!

    respond_to do |format|
      format.html {
        redirect_to @task, notice: "Task was succesfully #{"un" unless @task.done?}marked as done"
      }
      format.js
    end
  end

  def clear
    current_user.tasks.done.destroy_all

    redirect_to tasks_url(:show => :done), notice: "Done tasks were successfully cleared"
  end

  private

  def pick_show_parameter
    @show  = params[:show] || session[:show]
    @show  = "todo" unless @show.in? Task::SCOPES
    session[:show] = @show
  end
end
