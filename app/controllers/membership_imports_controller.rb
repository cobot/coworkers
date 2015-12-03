class MembershipImportsController < ApplicationController
  include RequireAdmin, LoadSpace

  def new
    existing_memberships = Membership.where(space_id: @space.id)
    @memberships = cobot_memberships.reject{|m|
      m[:canceled_to].present? && Date.parse(m[:canceled_to]) < Date.today ||
        existing_memberships.map(&:cobot_id).include?(m[:id])
    }.map{|attributes|
      Membership.new(cobot_id: attributes[:id], name: attributes[:name].to_s)
    }.sort_by(&:name)
  end

  def create
    ids = params[:memberships].try(:keys)
    if ids
      ids.each do |id|
        membership_details = cobot_client.get(@space.subdomain, "/memberships/#{id}")
        @space.memberships.create cobot_id: membership_details[:id],
          picture: membership_details[:picture],
          name: membership_details[:name]
      end
      flash[:notice] = 'Members successfully imported.'
    end
    redirect_to space_memberships_path(@space)
  end

  private

  def cobot_client
    CobotClient::ApiClient.new current_user.access_token
  end

  def cobot_memberships
    cobot_client.get(@space.subdomain, '/memberships')
  end
end
