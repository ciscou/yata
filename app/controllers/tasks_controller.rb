class TasksController < ApplicationController
  def index
    @show  = params[:show]
    @show  = "today" unless @show.in? %w[today tomorrow todo done]
    @tasks = Task.send(@show)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])

    if @task.save
      redirect_to tasks_url(:show => :todo), notice: 'Task was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      redirect_to tasks_url(:show => :todo), notice: 'Task was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.update_attributes(:done => !@task.done?)

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.js
    end
  end

  def clear
    Task.done.destroy_all

    redirect_to tasks_path(:show => :done)
  end
end
