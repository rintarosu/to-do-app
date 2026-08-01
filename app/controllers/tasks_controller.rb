class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy]

  def index
    # ヒント: @tasks に Task.all を入れる
    @tasks = Task.all
  end

  def new
    # ヒント: @task に Task.new を入れる(フォームが空のオブジェクトを参照するため)
    @task = Task.new
  end

  def create
    # ヒント: Task.new(task_params) で @task を作り、save が成功したら
    #        redirect_to tasks_path、失敗したら render :new
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def edit
    # set_task で @task は既にセット済みなので、ここは空でOK
  end

  def update
    # ヒント: @task.update(task_params) が成功したら redirect_to tasks_path、
    #        失敗したら render :edit
    if @task.update(task_params)
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def destroy
    # ヒント: @task.destroy して redirect_to tasks_path
    @task.destroy
    redirect_to tasks_path
  end

  private

  def set_task
    # ヒント: Task.find(params[:id]) を @task に入れる
    @task = Task.find(params[:id])
  end

  def task_params
    # ヒント: params.require(:task).permit(:title, :completed)
    params.require(:task).permit(:title, :completed)
  end
end
