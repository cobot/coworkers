class Space
  include CouchPotato::Persistence
  
  property :name
  
  view :by_id, key: :_id
  view :by_name, key: :name
  
  def memberships
    @memberships ||= database.view(Membership.by_space_id(id)).sort_by(&:last_name)
  end
  
  def questions
    @questions ||= database.view(Question.by_space_id(id))
  end
  
  def member?(user)
    database.first Membership.by_space_id_and_user_id([id, user.id])
  end
  alias_method :membership_for, :member?
end