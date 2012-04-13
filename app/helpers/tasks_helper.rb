module TasksHelper
  def link_to_destroy_task(task)
    icon, text, level = task.done? ? %w[remove Undo warning] : %w[ok Yata success]
    level = "danger" if task.delayed?
    link_to icon_and_text("icon-white icon-#{icon}", text), task,
      :remote       => true,
      :disable_with => "...",
      :method       => :delete,
      :class        => "btn btn-#{level} btn-mini"
  end
end
