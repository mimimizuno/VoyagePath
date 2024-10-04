class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :due_date, presence: true

  # ユーザーの繰り返しタスクを生成するメソッド
  def self.generate_tasks_for_user(user)
    # repetitionが設定してあるものを割り出す
    user.tasks.where("repetition IS NOT NULL").find_each do |task|
      repetition_data = JSON.parse(task.repetition)
      # 週毎
      if repetition_data['type'] == 'weekly'
        (Date.today.beginning_of_week..Date.today.end_of_week).each do |date|
          if repetition_data['days'].include?(date.strftime("%A"))
            create_task_if_not_exists(task, user, date)
          end
        end
      # 月毎
      elsif repetition_data['type'] == 'monthly'
        days_of_month = repetition_data['days'].map(&:to_i)
        (Date.today.beginning_of_month..Date.today.end_of_month).each do |date|
          if days_of_month.include?(date.day)
            create_task_if_not_exists(task, user, date)
          end
        end
      end
      delete_previous_repetitions(user, repetition_data['type'])
    end
  end

  # 前の週のタスクの繰り返し設定を削除する
  def self.delete_previous_repetitions(user, period)
    if period == "weekly"
      previous_week_range = (Date.today.beginning_of_week - 1.week)..(Date.today.end_of_week - 1.week)
      user.tasks.where(due_date: previous_week_range).update_all(repetition: nil)
    elsif period == "monthly"
      previous_month_range = (Date.today.beginning_of_month - 1.month)..(Date.today.end_of_month - 1.month)
      user.tasks.where(due_date: previous_month_range).update_all(repetition: nil)
    end
  end

  # 繰り返しのタスクがすでに生成されていない場合に繰り返しのタスクを生成
  def self.create_task_if_not_exists(original_task, user, date)
    unless Task.exists?(title: original_task.title, due_date: date, user_id: user.id)
      Task.create!(
        title: original_task.title,
        description: original_task.description,
        due_date: date,
        user: user,
        repetition: original_task.repetition,
        completed: false
      )
    end
  end

end
