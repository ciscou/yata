module ApplicationHelper
  def icon(id, opts = {})
    content_tag(:span, "", class: "fa #{"fa-fw" if opts[:fw]} fa-#{id}")
  end

  def icon_and_text(id, text, opts = {})
    [icon(id, opts), h(text)].join(" ").html_safe
  end

  def count_and_text(count, text, options = {})
    level = options[:level] || :info
    [
      content_tag(:span, count, :class => "label label-#{level}"),
      content_tag(:span, text , :class => "#{"text-danger" if level == :danger}")
    ].join(" ").html_safe
  end
end
