module TasksHelper

  # 英語の曜日を漢字で表すハッシュ
  DAYS_IN_JAPANESE = {
    "Sunday" => "日",
    "Monday" => "月",
    "Tuesday" => "火",
    "Wednesday" => "水",
    "Thursday" => "木",
    "Friday" => "金",
    "Saturday" => "土"
  }

  # 曜日を漢字に直して返す
  def translate_day(day)
    day_in_japanese = DAYS_IN_JAPANESE[day]
    "#{day_in_japanese}曜日"
  end

  # 複数曜日の英語を漢字に直してスペースで接続
  def translate_days_to_japanese(days)
    days.map { |day| DAYS_IN_JAPANESE[day] }.join(" ")
  end

  # 日付のフォーマットにして返す
  def format_date_with_japanese(date)
    day_in_japanese = DAYS_IN_JAPANESE[date.strftime("%A")]
    date.strftime("%Y年%m月%d日（") + day_in_japanese + "）"
  end


end
