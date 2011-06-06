class Answer
  include CouchPotato::Persistence
  
  property :question_id
  property :question
  property :text
  property :membership_id
  
  view :by_membership_id_and_created_at, key: [:membership_id, :created_at]
  view :by_question_id_and_membership_id, key: [:question_id, :membership_id]
end