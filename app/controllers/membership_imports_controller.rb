class MembershipImportsController < ApplicationController
  include RequireAdmin, LoadSpace

  def new
    existing_memberships = db.view(Membership.by_space_id(@space.id))
    @memberships = cobot_memberships.reject{|m|
      m['canceled_to'].present? && Date.parse(m['canceled_to']) < Date.today ||
        existing_memberships.map(&:id).include?(m['id'])
    }.map{|attributes|
      Membership.new(id: attributes['id'], name: attributes['address']['name'])
    }.sort_by(&:name)
  end

  def create
    ids = params[:memberships].try(:keys)
    if ids
      ids.each do |id|
        membership_details = access_token.get("#{@space.cobot_url}/api/memberships/#{id}").parsed
        db.save(Membership.new id: membership_details['id'],
          picture: membership_details['user'].try(:[], 'picture'),
          space_id: @space.id, name: membership_details['address']['name'])
      end
      flash[:notice] = 'Members successfully imported.'
    end
    redirect_to space_memberships_path(@space)
  end

  private

  def access_token
    @access_token ||= OAuth2::AccessToken.new oauth_client, current_user.access_token
  end

  def cobot_memberships
    access_token.get("#{@space.cobot_url}/api/memberships").parsed
  end
end
