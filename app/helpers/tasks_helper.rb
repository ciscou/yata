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

  def time_ago_or_since_in_words(datetime)
    difference = time_ago_in_words datetime
    if datetime.past?
      "#{difference} ago"
    else
      "In #{difference}"
    end
  end
end
