require 'digest/md5'

module Api
  class SpacesController < ApplicationController
    include ApplicationHelper
    skip_before_filter :require_authentication, only: :show
    skip_before_filter :verify_authenticity_token, only: :show

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
      if params[:callback].blank?
        render json: space_hash(space)
      else
        render js: "#{params[:callback]}(#{space_hash(space).to_json});"
      end
    end

    def space_hash(space)
      memberships = space.memberships.active.published.includes(:answers)
      {
        id: space.id,
        name: space.name,
        url: space_url(space),
        memberships: memberships.map do |membership|
          membership_hash(space, membership,
            membership.answers)
        end
      }
    end

    def membership_hash(space, membership, answers)
      {
        id: membership.id,
        name: membership.name,
        url: space_membership_url(space, membership),
        image_url: membership_picture_url(membership, size: (params[:picture_size] || :small)),
        website: membership.website,
        bio: membership.bio,
        profession: membership.profession,
        industry: membership.industry,
        skills: membership.skills,
        messenger: ({membership.messenger_type => membership.messenger_account} if membership.messenger_type.present?),
        questions: answers.map do |answer|
          {answer.question => answer.text}
        end
      }
    end
  end
end
