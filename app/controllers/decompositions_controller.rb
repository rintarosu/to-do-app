class DecompositionsController < ApplicationController
    before_action :set_task

    def new
    end

    def create
        titles = params[:titles].split("\n")
        titles.each do |title|
          @task.children.create(title: title, user: Current.user) unless title.nil?
        end
        redirect_to tasks_path
    end

    private

  def set_task
    # ヒント: params[:task_id] を使って Current.user.tasks から検索する
    @task = Current.user.tasks.find(params[:task_id])
  end
end
