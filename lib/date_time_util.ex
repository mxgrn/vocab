defmodule DateTimeUtil do
  @moduledoc false
  def time_ago(date, today \\ Date.utc_today()) do
    days = Date.diff(today, date)

    cond do
      days == 0 -> "today"
      days <= 1 -> "yesterday"
      days <= 28 -> "#{days} days ago"
      days <= 50 -> "a month ago"
      days <= 365 -> "#{ceil(days / 30)} months ago"
      days <= 550 -> "a year ago"
      true -> "#{ceil(days / 365)} years ago"
    end
  end
end
