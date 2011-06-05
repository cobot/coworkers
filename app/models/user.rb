class User
  include CouchPotato::Persistence
  
  property :login
  
  view :by_login, key: :login
end