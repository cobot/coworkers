require 'digest/md5'

module Api
  class SpacesController < ApplicationController
    skip_before_filter :require_authentication, only: :show

    def show
      space = Space.by_cobot_id(params[:id]).first!
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
      memberships = space.memberships.active.includes(:user, :answers)
      {
        id: space.id,
        name: space.name,
        url: url_for(space),
        memberships: memberships.map {|membership|
          membership_hash(space, membership,
            membership.user,
            membership.answers
        )}
      }
    end

    def membership_hash(space, membership, user, answers)
      {
        id: membership.id,
        name: membership.name,
        url: url_for([space, membership]),
        image_url: membership.picture,
        website: membership.website,
        bio: membership.bio,
        profession: membership.profession,
        industry: membership.industry,
        skills: membership.skills,
        messenger: ({membership.messenger_type => membership.messenger_account} if membership.messenger_type.present?),
        questions: answers.map{|answer|
          {answer.question => answer.text}
        }
      }
    end
  end
end
