class QuestionsController < ApplicationController
  def index
    @space = db.load! params[:space_id]
    @questions = db.view(Question.by_space_id_and_created_at(startkey: [@space.id], endkey: [@space.id, {}]))
    @question = Question.new
  end
  
  def create
    space = db.load! params[:space_id]
    return not_allowed unless current_user.admin_of?(space)
    question = Question.new params[:question]
    question.space_id = space.id
    db.save question
    redirect_to space_questions_path(space), notice: ('The question was added.' if question.valid?)
  end
  
  def destroy
    space = db.load! params[:space_id]
    return not_allowed unless current_user.admin_of?(space)
    question = db.load! params[:id]
    db.destroy question
    redirect_to space_questions_path(space), notice: 'The question was removed.'
  end
end