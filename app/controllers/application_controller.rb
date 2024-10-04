class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :check_for_updates
  
  private

  # アクションを呼び出すたびに経験値とタスク生成をチェック
  def check_for_updates
    return unless logged_in? && current_user
    # 最後の経験値計算の更新が今日よりも前なら経験値を計算
    if current_user.last_experience_update_at.nil? || current_user.last_experience_update_at < Date.today
      # ログイン前の経験値とレベルを保存
      initial_experience_points = current_user.experience_points
      initial_level = current_user.level
      # ログイン時に経験値を計算する(レベルアップ処理を含む)
      current_user.calculate_experience_on_login
      current_user.save
      # debugger
      if current_user.experience_points > initial_experience_points
        flash.now[:notice] = "Welcome back! Your experience points have been updated!"
      end
      if current_user.level > initial_level
        flash.now[:notice] = "Congratulations! You have leveled up to level #{current_user.level}!!"
      end
    end

    # 最後のタスク生成の更新が今日よりも前なら生成
    if current_user.last_task_update_at.nil? || current_user.last_task_update_at < Date.today
      initial_tasks_count = current_user.tasks.count
      Task.generate_tasks_for_user(current_user)
      current_user.update(last_task_update_at: Date.today)
      if current_user.tasks.count > initial_tasks_count
        flash.now[:notice] = "Recurring tasks have been generated!"
      end
    end
  end
      
end
