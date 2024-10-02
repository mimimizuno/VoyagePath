class User < ApplicationRecord
  # concernをインクルード
  include ExperienceCalculator

  has_many :tasks, dependent: :destroy
  has_many :user_avatars, dependent: :destroy
  has_many :avatars, through: :user_avatars
  attr_accessor :remember_token
  validates :user_name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :goal, length: { maximum: 255 }
  # ユーザー作成時にレベル1のアバターを獲得する
  after_create :add_level_1_avatar
  # レベル変更時にアバターを獲得
  before_update :acquire_new_avatars, if: :will_save_change_to_level?

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを生成
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続的なセッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アクティブなアバターを取得
  def active_avatar
    user_avatars.find_by(is_active: true)&.avatar
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

    # 指定された期間（日付範囲）でタスク達成率を取得
  def completion_rates_for_period(start_date, end_date)
    (start_date..end_date).map do |date|
      daily_tasks = tasks.where(due_date: date)
      {
        date: date,
        completion_rate: calculate_completion_rate(daily_tasks)
      }
    end
  end

  # 週ごとの達成率
  def weekly_completion_rates
    completion_rates_for_period(Date.today.beginning_of_week, Date.today.end_of_week)
  end

  # 月ごとの達成率
  def monthly_completion_rates
    completion_rates_for_period(Date.today.beginning_of_month, Date.today.end_of_month)
  end

  # 年ごとの達成率
  def yearly_completion_rates
    completion_rates_for_period(Date.today.beginning_of_year, Date.today.end_of_year)
  end

  # before action
  # レベル1のアバターを獲得する
  def add_level_1_avatar
    level_1_avatar = Avatar.find_by(required_level: 1)
    self.avatars << level_1_avatar
  end

  # レベル変更時に新しいアバターを獲得
  def acquire_new_avatars
    Avatar.where("required_level <= ?", self.level).each do |avatar|
      self.avatars << avatar unless self.avatars.include?(avatar)
    end
  end

end
