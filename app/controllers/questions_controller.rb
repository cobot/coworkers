class QuestionsController < ApplicationController
  include RequireAdmin, LoadSpace

  def index
    @questions = @space.questions
    @question = Question.new
  end

  def create
    question = Question.new params[:question]
    question.space_id = @space.id
    question.save
    redirect_to space_questions_path(@space), notice: ('The question was added.' if question.valid?)
  end

  def destroy
    question = @space.questions.find params[:id]
    question.destroy
    redirect_to space_questions_path(@space), notice: 'The question was removed.'
  end
end
