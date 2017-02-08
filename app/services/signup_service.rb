class SignupService
  def initialize(user_attributes, access_token, routes)
    @user_attributes = user_attributes
    @access_token = access_token
    @routes = routes
  end

  def run
    user = find_and_update_or_create_user user_attributes
    create_memberships user, user_attributes[:memberships]
    create_spaces user_attributes[:admin_of].map {|admin_of| admin_of[:space_link] }
    user
  end

  private

  attr_reader :access_token, :user_attributes

  def create_spaces(links)
    links.each do |link|
      find_or_create_space link, create_webhooks: true
    end
  end

  def find_and_update_or_create_user(user_attributes)
    user = User.where(cobot_id: user_attributes[:id]).first
    if user
      user.email = user_attributes[:email]
      user.admin_of = admin_spaces(user_attributes)
      user.access_token = access_token
      user.save if user.changed?
    else
      user = User.new(
        cobot_id: user_attributes[:id],
        email: user_attributes[:email],
        admin_of: admin_spaces(user_attributes),
        access_token: access_token
      )
      user.save
    end
    user
  end

  def create_memberships(user, memberships_attributes)
    memberships_attributes.each do |membership_attributes|
      membership_details = oauth_get(membership_attributes[:link])
      membership = Membership.where(cobot_id: membership_details[:id]).first
      if !membership_details[:confirmed_at].nil? && !membership_details[:canceled_to] && !membership
        Membership.create user_id: user.id, cobot_id: membership_details[:id],
          space_id: find_or_create_space(membership_attributes[:space_link]).id,
          picture: membership_details[:picture],
          name: membership_details[:name]
      elsif membership
        membership.name = membership_details[:name]
        membership.picture = membership_details[:picture]
        membership.user_id = user.id
        membership.canceled_to = membership_details[:canceled_to]
        membership.save!
      end
    end
  end

  def find_or_create_space(space_url, create_webhooks: false)
    space_attributes = oauth_get(space_url)
    unless space = Space.where(cobot_id: space_attributes[:id]).first
      space = Space.create name: space_attributes[:name], cobot_id: space_attributes[:id],
        cobot_url: space_attributes[:url]
      if create_webhooks
        cobot_client.post space.subdomain, '/subscriptions',
          event: 'canceled_membership',
          callback_url: @routes.space_member_cancellation_webhook_url(space.webhook_secret)
      end
    else
      space.cobot_url = space_attributes[:url] # for old spaces who don't have it set yet
      space.save validate: false
    end
    space
  end

  def admin_spaces(user_attributes)
    user_attributes[:admin_of].reduce({}) do |hash, space_attributes|
      hash[oauth_get(space_attributes[:space_link])[:id]] = space_attributes[:name]
      hash
    end
  end

  def cobot_client
    CobotClient::ApiClient.new @access_token
  end

  def oauth_get(url)
    cobot_client.get(url)
  end
end
