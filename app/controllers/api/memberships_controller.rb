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
        image_url: user_image_url(membership.user),
        login: membership.user.login,
        website: membership.user.website,
        bio: membership.user.bio,
        profession: membership.user.profession,
        industry: membership.user.industry,
        skills: membership.user.skills
      }
    end
    
    def user_image_url(user, size = 50, secure = request.ssl?)
      email = "info@cobot.me"
      email = user.email unless user.email.nil?

      md5 = Digest::MD5.hexdigest(email)
      if secure
        "https://secure.gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
      else
        "http://gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
      end
    end
  end
end