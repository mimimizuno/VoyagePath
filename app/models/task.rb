class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :due_date, presence: true

  # 繰り返しが今日にあるかどうか（引数：引数の日で判定）
  def repeat_today?(date = Date.today)
    return false if repetition.blank?

    repetition_data = JSON.parse(repetition)

    case repetition_data['type']
    when 'weekly'
      repetition_data['days'].include?(date.strftime("%A"))
    when 'monthly'
      date.day == repetition_data['day']
    else
      false
    end
  end

end
