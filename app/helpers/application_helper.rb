module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(safe_links_only: true,
      link_attributes: {target: '_top'})
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(text.to_s).html_safe
  end

  def menu(&block)
    content_for :menu, &block
  end
end
