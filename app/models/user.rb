class User
  include CouchPotato::Persistence
  
  property :login
  property :admin_of, default: [] # space ids

  # profile information
  property :website
  property :bio
  property :profession
  property :industry
  property :skills
  property :messenger_type
  property :messenger_account
  
  view :by_login, key: :login
end