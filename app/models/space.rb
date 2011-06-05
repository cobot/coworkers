class Space
  include CouchPotato::Persistence
  
  property :name
  
  view :by_id, key: :_id
  
  def memberships
    @memberships ||= database.view(Membership.by_space_id(id))
  end
end