defmodule DateTimeUtil do
  def time_ago(date, today \\ Date.utc_today()) do
    days = Date.diff(today, date)

    cond do
      days == 0 -> "today"
      days <= 1 -> "yesterday"
      days <= 28 -> "#{days} days ago"
      days <= 50 -> "a month ago"
      days <= 365 -> "#{(days / 30) |> ceil()} months ago"
      days <= 550 -> "a year ago"
      true -> "#{(days / 365) |> ceil()} years ago"
    end
  end
end
