module ApplicationHelper
  def icon_and_text(icon, text)
    [content_tag(:span, "", class: "glyphicon glyphicon-#{icon}"), text].join(" ").html_safe
  end

  def count_and_text(count, text, options = {})
    level = options[:level] || :info
    [
      content_tag(:span, count, :class => "label label-#{level}"),
      content_tag(:span, text , :class => "#{"text-danger" if level == :danger}")
    ].join(" ").html_safe
  end
end
