class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = Current.user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Current.user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path
    else
      redirect_to tasks_path, alert: @task.errors.full_messages.to_sentence

    end
  end

  private

  def set_task
    @task = Current.user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
