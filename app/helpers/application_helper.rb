module ApplicationHelper
  include CobotClient::UrlHelper

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(safe_links_only: true,
      link_attributes: {target: '_top'})
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(text.to_s).html_safe
  end

  def menu(&block)
    content_for :menu, &block
  end

  def membership_picture_url(membership, size: :small)
    cobot_url membership.space.subdomain, "/api/memberships/#{membership.cobot_id}/picture",
      params: {picture_size: size}
  end
end
