class MemberCancellationWebhooksController < ActionController::Base
  def create
    space = Space.where(webhook_secret: params[:space_id]).first!
    begin
      api_membership = cobot_client(space.access_token).get params[:url]
      if (membership = space.memberships.where(cobot_id: api_membership[:id]).first)
        membership.update_attribute :canceled_to, api_membership[:canceled_to]
      end
    rescue CobotClient::ResourceNotFound
      membership_id = URI.parse(params[:url]).path.split('/').last
      if (membership = space.memberships.where(cobot_id: membership_id).first)
        membership.destroy
      end
    end
    head 204
  end

  private

  def cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end
end
