class MembershipsController < ApplicationController
  include LoadSpace
  skip_before_filter :require_authentication, only: :show
  param_protected({membership: [:space_id, :user_id]}, only: :update)
  param_protected({user: [:cobot_id, :admin_of, :email, :access_token]}, only: :update)

  def index
    if !@space.viewable_by?(current_user)
      not_allowed
    else
      scope = @space.memberships.active.includes(:user)
      scope  = scope.published unless current_user.admin_of?(@space)
      @memberships = scope.sort_by {|m| m.name.to_s.downcase }
    end
  end

  def edit
    @membership = @space.memberships.find params[:id]
    return not_allowed unless check_access @membership
    @questions = Question.where(space_id: @space.id)
    @answers = Answer.where(membership_id: @membership.id)
  end

  def update
    @membership = @space.memberships.find params[:id]
    return not_allowed unless check_access @membership
    @membership.attributes = membership_params
    if (picture = params.dig(:membership, :picture))
      cobot_client(@space.access_token).put(@space.subdomain,
        "/memberships/#{@membership.cobot_id}/picture", data: "data:#{picture.content_type};base64,#{Base64.encode64(picture.read)}")
    end
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
    @membership = @space.memberships.find params[:id]
    @user = @membership.user
  end

  def destroy
    @membership = @space.memberships.find params[:id]
    return not_allowed unless check_access @membership
    @membership.destroy
    redirect_to [@space, :memberships], notice: 'The profile was removed.'
  end

  def check_access(membership)
    current_user&.admin_of?(@space) ||
      (current_user&.member_of?(@space) && current_user&.membership_for(@space)&.id == membership.id)
  end

  def cobot_client(access_token)
    @cobot_client ||= CobotClient::ApiClient.new access_token
  end

  def membership_params
    params[:membership].permit(:name, :website,
      :messenger_type, :messenger_account, :bio,
      :profession, :industry, :skills, :public)
  end
end
