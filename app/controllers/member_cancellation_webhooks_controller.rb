class MemberCancellationWebhooksController < ActionController::Base
  def create
    space = Space.where(webhook_secret: params[:space_id]).first!
    membership_id = URI.parse(params[:url]).path.split('/').last
    membership = space.memberships.where(cobot_id: membership_id).first
    begin
      api_membership = cobot_client(space.access_token).get params[:url]
    rescue CobotClient::ResourceNotFound
      membership.destroy if membership
      head 204
    rescue CobotClient::Forbidden
      # the default_admin is no longer an admin
      if space.admins.count > 1
        space.default_admin.destroy
        retry
      else
        head 403
      end
    else
      if membership
        membership.update_attribute :canceled_to, api_membership[:canceled_to]
      end
      head 204
    end
  end

  private

  def cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end
end
