module TasksHelper
  def link_to_destroy_task(task, show = false)
    icon, text, level = task.done? ? %w[remove Undo inverse] : %w[ok Yata success]
    level = "danger" if task.delayed?
    link_to icon_and_text("icon-white icon-#{icon}", text), task,
      :remote       => !show,
      :disable_with => "...",
      :method       => :delete,
      :class        => "btn btn-#{level} #{"btn-mini" unless show}"
  end

  def reminder_beforehand_due_at(task)
    reminder_beforehand_due_at_options.invert[task.reminder_send_before_due_at] || "Never"
  end

  def reminder_beforehand_due_at_options
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

  def time_ago_or_since_in_words(datetime)
    difference = time_ago_in_words datetime
    if datetime.past?
      "#{difference} ago"
    else
      "In #{difference}"
    end
  end

  def task_due_at(task)
    task.due_at.strftime "%A, %B %d, %Y %H:%M"
  end

  def task_class(task)
    [
      task.done?    ? "done"    : "todo",
      task.delayed? ? "delayed" : "on-time"
    ].join(" ")
  end
end
