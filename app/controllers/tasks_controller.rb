class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy tree]

  def index
    @tasks = Current.user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Current.user.tasks.new(task_params)
    if @task.save
      sync_tags(@task)
      redirect_to tasks_path
    else
      render :new
    end
  end

  def edit
  end

  def tree
  end

  def update
    if @task.update(task_params)
      sync_tags(@task)
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

   def sync_tags(task)
    names = params[:tag_names].split(",").map(&:strip).reject(&:blank?)
    tags = names.map { |name| Current.user.tags.find_or_create_by(name: name) }
    task.tags = tags
  end
end
