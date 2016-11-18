module TasksHelper
  def reminder_options
    {
      "On time"             => 0,
      "15 minutes before"   => 15,
      "Half an hour before" => 30,
      "One hour before"     => 60,
      "Two hours before"    => 60 * 2,
      "Three hours before"  => 60 * 3,
      "Six hours before"    => 60 * 6,
      "Twelve hours before" => 60 * 12,
      "One day before"      => 60 * 24,
      "Two days before"     => 60 * 24 * 2,
      "One week before"     => 60 * 24 * 7
    }
  end

  def repeat_every_options
    [
      "8 hours",
      "12 hours",
      "1 day",
      "1 week",
      "2 weeks",
      "4 weeks",
      "1 month",
      "3 months",
      "6 months",
      "1 year"
    ]
  end

  def time_ago_or_since_in_words(datetime)
    difference = time_ago_in_words datetime
    suffix = datetime.past? ? "ago" : "from now"
    "#{difference} #{suffix}"
  end

  def jquery_time_ago(datetime)
    return if datetime.nil?

    content_tag :abbr, format_due_at(datetime), class: "timeago", title: datetime.iso8601
  end

  def format_due_at(datetime)
    return if datetime.nil?

    datetime.strftime "%A, %B %d, %Y %H:%M"
  end

  def task_class(task)
    [
      task.done?        ? "done"    : "todo",
      task.due_at.past? ? "delayed" : "on-time"
    ].join(" ")
  end

  def todo_tasks_path
    tasks_path
  end

  def bank_holidays
    [
      [2015,  5,  1],
      [2015,  5,  2],
      [2015,  5, 15],
      [2015,  6,  4],
      [2015,  8, 15],
      [2015, 10, 12],
      [2015, 11,  9],
      [2015, 12,  8],
      [2015, 12, 25],
      [2016,  1,  1]
    ]
  end
end
