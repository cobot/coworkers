module Api
  class MembershipsController < ApplicationController
    skip_before_filter :require_authentication, only: :show

    def show
      @space = db.load params[:space_id]
      @membership = db.load params[:id]
      unless params[:callback].blank?
        render js: "#{params[:callback]}(#{membership_hash(@membership).to_json});"
      else
        render json: membership_hash(@membership)
      end
    end

    def membership_hash(membership)
      {
        id: membership._id,
        name: membership.name,
        image_url: membership.user.picture,
        website: membership.user.website,
        bio: membership.user.bio,
        profession: membership.user.profession,
        industry: membership.user.industry,
        skills: membership.user.skills
      }
    end
  end
end
