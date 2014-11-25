module TasksHelper
  def link_to_destroy_task(task, show = false)
    icon, text, level, action = task.done? ? %w[remove Undo default unmark_as_done] : %w[ok Yata success mark_as_done]
    level = "danger" if task.delayed?

    link_to icon_and_text(icon, text), [action, task],
      remote: !show,
      method: :patch,
      class:  "btn btn-#{level} #{show ? "btn-lg" : "btn-xs"}",
      data: {
        disable_with: "Wait..."
      }
  end

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
      "One week before"     => 60 * 24 * 7
    }
  end

  def repeat_every_options
    [
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
      task.done?    ? "done"    : "todo",
      task.delayed? ? "delayed" : "on-time"
    ].join(" ")
  end

  def tasks_index_subtitle(show, category_id, category)
    if category.present?
      category.name
    elsif category_id == ''
      'Uncategorized'
    else
      Task::SCOPES[show]
    end
  end
end
