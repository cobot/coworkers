module UsersHelper
  def last_user
    DB.first! User.by_email
  end
end

World(UsersHelper)
