module MarkdownHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new hard_wrap: true
    markdown = Redcarpet::Markdown.new renderer

    markdown.render(text).html_safe
  end
end
