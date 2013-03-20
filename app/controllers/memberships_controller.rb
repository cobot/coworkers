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
      @memberships = @space.memberships.includes(:user)
      @memberships.sort_by!{|m| m.name.downcase}
    end
  end

  def edit
    check_access
    @membership = Membership.find params[:id]
    @questions = Question.where(space_id: @space.id)
    @answers = Answer.where(membership_id: @membership.id)
  end

  def picture
    check_access
    @membership = Membership.find params[:id]
    @membership.picture = cobot_client(current_user.access_token).get("#{@space.cobot_url}/api/memberships/#{@membership.cobot_id}").parsed['picture']
    @membership.save validate: false
    redirect_to [:edit, @space, @membership], notice: 'Picture updated.'
  end

  def update
    @membership = Membership.find params[:id]
    @membership.attributes = params[:membership]
    if @membership.save
      (params[:answers] || {}).values.each do |answer_params|
        question = Question.where(id: answer_params[:question]).first
        answer = Answer.where(question_id: answer_params[:question], membership_id: @membership.id).first || Answer.new(question_id: answer_params[:question], membership_id: @membership.id)
        answer.text = answer_params[:text]
        answer.question = question.text
        answer.save
      end
      redirect_to [@space, @membership]
    else
      render 'edit'
    end
  end

  def show
    @membership = Membership.find params[:id]
    @user = @membership.user
  end

  def destroy
    @membership = Membership.find params[:id]
    @membership.destroy
    redirect_to [@space, :memberships], notice: 'The profile was removed.'
  end

  def check_access
    not_allowed unless current_user.try(:admin_of?, @space) || current_user.try(:member_of?, @space)
  end

  def cobot_client(access_token)
    @cobot_client ||= OAuth2::AccessToken.new oauth_client, access_token
  end
end
