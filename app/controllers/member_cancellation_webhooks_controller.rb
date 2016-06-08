class MemberCancellationWebhooksController < ActionController::Base
  def create
    space = Space.where(webhook_secret: params[:space_id]).first!
    api_membership = cobot_client(space.access_token).get params[:url]
    if (membership = space.memberships.where(cobot_id: api_membership[:id]).first)
      membership.update_attribute :canceled_to, api_membership[:canceled_to]
    end
    head 204
  end

  private

  def cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end
end
