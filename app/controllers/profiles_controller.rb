class ProfilesController < ApplicationController
  include LoadSpace

  def edit
    @membership = @space.membership_for(current_user)
    @questions = db.view(Question.by_space_id_and_created_at(startkey: [@space.id], endkey: [@space.id, {}]))
    @answers = db.view(Answer.by_membership_id_and_created_at(startkey: [@membership.id], endkey: [@membership.id, {}]))
  end

  def update
    @membership = @space.membership_for(current_user)

    params[:answers].values.each do |answer_params|
      question = db.load answer_params[:question]
      answer = db.first(Answer.by_question_id_and_membership_id([answer_params[:question], @membership.id])) || Answer.new(question_id: answer_params[:question], membership_id: @membership.id)
      answer.text = answer_params[:text]
      answer.question = question.text
      db.save answer
    end

    redirect_to space_path(@space), notice: 'Profile updated.'
  end
end
