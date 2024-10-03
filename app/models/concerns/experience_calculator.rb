module ExperienceCalculator
  extend ActiveSupport::Concern
  
  # タスク達成率を計算する共通メソッド
  def calculate_completion_rate(tasks)
    total_tasks = tasks.count
    completed_tasks = tasks.where(completed: true).count
    # 分母が0なら0を返す
    return 0 if total_tasks.zero?
    (completed_tasks.to_f / total_tasks.to_f)
  end
  
  # 経験値を加算する共通メソッド
  def add_experience(points)
    self.experience_points += points
    check_level_up
    save
  end

  # ログイン時に経験値を計算するメソッド
  def calculate_experience_on_login
    last_calculation_date = self.last_experience_update_at || Date.yesterday

    # 基準日から今日までの経験値を計算
    (last_calculation_date...Date.today).each do |date|
      update_daily_experience(based_on: date)

      # もし日付が月曜日なら週の経験値を計算
      update_weekly_experience(based_on: date) if date.monday?

      # もし日付が月の初日なら月の経験値を計算
      update_monthly_experience(based_on: date) if date.day == 1
    end

    # 経験値計算後、最新の更新日を保存
    self.update(last_experience_update_at: Date.today)
  end

  # 日々の経験値を基準日を指定して計算
  def update_daily_experience(based_on: Date.today)
    daily_tasks = tasks.where(due_date: based_on)
    completion_rate = calculate_completion_rate(daily_tasks)
    experience_gained = ((completion_rate * 3).round + daily_tasks.where(completed: true).count)
    add_experience(experience_gained)
  end

  # 週の経験値を基準日を指定して計算
  def update_weekly_experience(based_on: Date.today)
    start_of_week = based_on.beginning_of_week
    end_of_week = based_on.end_of_week
    weekly_tasks = tasks.where(due_date: start_of_week..end_of_week)
    completion_rate = calculate_completion_rate(weekly_tasks)
    experience_gained = (completion_rate * 10).round
    add_experience(experience_gained)
  end

  # 月の経験値を基準日を指定して計算
  def update_monthly_experience(based_on: Date.today)
    start_of_month = based_on.beginning_of_month
    end_of_month = based_on.end_of_month
    monthly_tasks = tasks.where(due_date: start_of_month..end_of_month)
    completion_rate = calculate_completion_rate(monthly_tasks)
    experience_gained = (completion_rate * 30).round
    add_experience(experience_gained)
  end

  # レベルアップに必要な経験値をレベルごとに計算
  def experience_for_next_level
    self.level * 100
  end

  # レベルアップを確認する
  def check_level_up
    while self.experience_points >= experience_for_next_level
      self.experience_points -= experience_for_next_level
      self.level += 1
    end
  end

end