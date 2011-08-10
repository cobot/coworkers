module UsersHelper
  def last_user
    DB.first! User.by_login
  end
end

World(UsersHelper)