module ApplicationHelper
  def icon_and_text(icon, text)
    [content_tag(:i, "", :class => icon), text].join(" ").html_safe
  end
end
