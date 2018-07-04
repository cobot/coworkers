class MembershipImportsController < ApplicationController
  include LoadSpace
  include RequireAdmin

  layout 'embed'

  def new
    existing_memberships = Membership.active.where(space_id: @space.id)
    @memberships =
      cobot_memberships
      .reject {|m| existing_memberships.map(&:cobot_id).include?(m[:id]) }
      .map {|attributes| Membership.new(cobot_id: attributes[:id], name: attributes[:name].to_s) }
      .sort_by(&:name)
  end

  def create
    ids = params[:memberships].try(:keys)
    if ids
      ids.each do |id|
        membership_details = cobot_client.get(@space.subdomain, "/memberships/#{id}")
        Membership.create_from_cobot membership_details, @space
      end
      flash[:notice] = 'Members successfully imported.'
    end
    redirect_to space_memberships_path(@space)
  end

  private

  def cobot_client
    CobotClient::ApiClient.new @space.access_token
  end

  def cobot_memberships
    cobot_client.get(@space.subdomain, '/memberships', attributes: 'name,id')
  end
end
