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
    save
  end
end