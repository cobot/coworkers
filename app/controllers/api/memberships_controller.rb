module Api
  class MembershipsController < ApplicationController
    skip_before_filter :require_authentication, only: :show

    def show
      @space = Space.find params[:space_id]
      @membership = @space.memberships.active.find params[:id]
      unless params[:callback].blank?
        render js: "#{params[:callback]}(#{membership_hash(@membership).to_json});"
      else
        render json: membership_hash(@membership)
      end
    end

    def membership_hash(membership)
      {
        id: membership.id,
        name: membership.name,
        image_url: membership.picture,
        website: membership.website,
        bio: membership.bio,
        profession: membership.profession,
        industry: membership.industry,
        skills: membership.skills
      }
    end
  end
end
