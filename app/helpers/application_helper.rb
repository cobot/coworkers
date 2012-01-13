module ApplicationHelper
  def markdown(text)
    RDiscount.new(text.to_s, :autolink).to_html.html_safe
  end

  def menu(&block)
    content_for :menu, &block
  end
end
