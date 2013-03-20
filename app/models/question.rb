class Question < ActiveRecord::Base

  validates_presence_of :text, :question_type
end
