class QuestionsController < ApplicationController
  include RequireAdmin, LoadSpace

  def index
    @questions = db.view(Question.by_space_id_and_created_at(startkey: [@space.id], endkey: [@space.id, {}]))
    @question = Question.new
  end

  def create
    question = Question.new params[:question]
    question.space_id = @space.id
    db.save question
    redirect_to space_questions_path(@space), notice: ('The question was added.' if question.valid?)
  end

  def destroy
    question = db.load! params[:id]
    db.destroy question
    redirect_to space_questions_path(@space), notice: 'The question was removed.'
  end
end
