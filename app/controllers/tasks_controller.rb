class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :correct_user

  def index
    @tasks = @user.tasks.order(due_date: :desc).paginate(page: params[:page], per_page: 5 )
  end

  def show
  end

  def new
    @task = @user.tasks.build
  end

  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      redirect_to user_task_path(@user, @task), notice: 'タスクの生成に成功しました'
      repetition_check
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to user_task_path(@user, @task), notice: 'タスクの編集に成功しました'
      repetition_check
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to @user, notice: 'タスクが削除されました'
  end

  # 週ごとのタスクを表示するアクション
  def week
    # パラメータが送られてきたらそれをstart_dateに、なければ今週の月曜日
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
    @end_date = @start_date + 6.days

    # 1週間分のタスクを取得
    @week_tasks = @user.tasks.where(due_date: @start_date..@end_date)
  end

  # 複数のタスクを同時に更新するアクション
  def bulk_update
    tasks_params.each do |id, task_data|
      task = @user.tasks.find(id)
      task.update(task_data.permit(:completed))
    end
    redirect_to @user, notice: 'タスクが更新されました。'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  end


  def task_params
    if params[:task][:repetition_days] != nil
      repetition_data = {
        type: params[:task][:repetition_type],
        days: params[:task][:repetition_days]
      }.to_json
    else 
      repetition_data = nil
    end
    params.require(:task).permit(:title, :description, :due_date, :completed).merge(repetition: repetition_data)
  end

  # 繰り返し処理の生成
  def repetition_check
    initial_tasks_count = @user.tasks.count
    Task.generate_tasks_for_user(@user)
    @user.update(last_task_update_at: Date.today)
    if @user.tasks.count > initial_tasks_count
      flash[:notice] = "繰り返しのタスクが生成されました"
    end
  end

  def tasks_params
    params.require(:tasks)
  end

end
