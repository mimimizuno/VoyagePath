class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = @user.tasks
  end

  def show
  end

  def new
    @task = @user.tasks.build
  end

  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      redirect_to user_tasks_path(@user), notice: 'Task was successfully created.'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to user_task_path(@user, @task), notice: 'Task was successfully updated.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to user_tasks_path(@user), notice: 'Task was successfully destroyed.'
  end

  # 週ごとのタスクを表示するアクション
  def week
    # パラメータが送られてきたらそれをstart_dateに、なければ今週の月曜日
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
    @end_date = @start_date + 6.days

    # 1週間分のタスクを取得
    @week_tasks = @user.tasks.where(due_date: @start_date..@end_date)
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :repetition, :completed)
  end
end
