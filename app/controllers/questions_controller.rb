class QuestionsController < ApplicationController
  include RequireAdmin, LoadSpace

  def index
    @questions = @space.questions
    @question = Question.new
  end

  def create
    question = Question.new question_params
    question.space_id = @space.id
    question.save
    redirect_to space_questions_path(@space), notice: ('The question was added.' if question.valid?)
  end

  def edit
    @question = @space.questions.find params[:id]
  end

  def update
    @question = @space.questions.find params[:id]
    @question.attributes = question_params
    if @question.save
      flash[:notice] = 'Question updated.'
      redirect_to space_questions_path(@space)
    else
      render 'edit'
    end
  end

  def destroy
    question = @space.questions.find params[:id]
    question.destroy
    redirect_to space_questions_path(@space), notice: 'The question was removed.'
  end

  private

  def question_params
    params[:question].permit(:text, :question_type)
  end
end
