require 'digest/md5'

module Api
  class SpacesController < ApplicationController
    skip_before_filter :require_authentication, only: :show

    def show
      space = db.load! params[:id]
      if space.viewable_by?(nil) || space.secret == params[:secret]
        render_space(space)
      else
        not_allowed
      end
    end

    private

    def render_space(space)
      unless params[:callback].blank?
        render js: "#{params[:callback]}(#{space_hash(space).to_json});"
      else
        render json: space_hash(space)
      end
    end
    
    def space_hash(space)
      {
        id: space._id,
        name: space.name,
        url: url_for(space),
        memberships: space.memberships.map {|membership| membership_hash(space, membership)}
      }
    end
    
    def membership_hash(space, membership)
      {
        id: membership._id,
        name: membership.name,
        url: url_for([space, membership]),
        image_url: membership.user.picture,
        login: membership.user.login,
        website: membership.user.website,
        bio: membership.user.bio,
        profession: membership.user.profession,
        industry: membership.user.industry,
        skills: membership.user.skills
      }
    end
  end
end