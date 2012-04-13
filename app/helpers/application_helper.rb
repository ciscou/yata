module ApplicationHelper
  def icon_and_text(icon, text)
    [content_tag(:i, "", :class => icon), text].join(" ").html_safe
  end

  def count_and_text(count, text, options = {})
    level = options[:level] || :info
    [
      content_tag(:span, count, :class => "badge badge-#{level}"),
      content_tag(:span, text , :class => level)
    ].join(" ").html_safe
  end
end
