class MembershipsController < ApplicationController
  include LoadSpace
  skip_before_filter :require_authentication, only: :show
  before_filter :check_access, except: [:index, :show]
  param_protected({membership: [:space_id, :user_id]}, only: :update)
  param_protected({user: [:cobot_id, :admin_of, :email, :access_token]}, only: :update)

  def index
    if !@space.viewable_by?(current_user)
      not_allowed
    else
      @memberships = @space.memberships
      users = db.view(User.by_id(keys: @memberships.map(&:user_id)))
      @memberships.each {|m| m.user = users.find{|u| u.id == m.user_id}}
    end
  end

  def edit
    check_access
    @membership = db.load! params[:id]
    @questions = db.view(Question.by_space_id_and_created_at(startkey: [@space.id], endkey: [@space.id, {}]))
    @answers = db.view(Answer.by_membership_id_and_created_at(startkey: [@membership.id], endkey: [@membership.id, {}]))
  end

  def picture
    check_access
    @membership = db.load! params[:id]
    @membership.picture = cobot_client(@membership.user.access_token).get('/api/user').parsed['picture']
    db.save @membership, false
    redirect_to [:edit, @space, @membership], notice: 'Picture updated.'
  end

  def update
    @membership = db.load! params[:id]
    @membership.attributes = params[:membership]
    if db.save(@membership)
      (params[:answers] || {}).values.each do |answer_params|
        question = db.load answer_params[:question]
        answer = db.first(Answer.by_question_id_and_membership_id([answer_params[:question], @membership.id])) || Answer.new(question_id: answer_params[:question], membership_id: @membership.id)
        answer.text = answer_params[:text]
        answer.question = question.text
        db.save answer
      end
      redirect_to [@space, @membership]
    else
      render 'edit'
    end
  end

  def show
    @membership = db.load! params[:id]
    @user = @membership.user
  end

  def destroy
    @membership = db.load! params[:id]
    db.destroy @membership
    redirect_to [@space, :memberships], notice: 'The profile was removed.'
  end

  def check_access
    not_allowed unless current_user.try(:admin_of?, @space) || current_user.try(:member_of?, @space)
  end

  def cobot_client(access_token)
    @cobot_client ||= OAuth2::AccessToken.new oauth_client, access_token
  end
end
