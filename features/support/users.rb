module UsersHelper
  def last_user
    User.first
  end
end

World(UsersHelper)
