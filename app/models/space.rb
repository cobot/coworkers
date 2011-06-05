class Space
  include CouchPotato::Persistence
  
  property :name
  
  view :by_id, key: :_id
  view :by_name, key: :name
  
  def memberships
    @memberships ||= database.view(Membership.by_space_id(id))
  end
end