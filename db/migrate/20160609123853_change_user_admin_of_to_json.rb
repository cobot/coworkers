class ChangeUserAdminOfToJson < ActiveRecord::Migration
  def up
    admins = User.all.map {|u| [u.id, u.admin_of] }.reject {|u| u[1].empty? }
    remove_column :users, :admin_of
    add_column :users, :admin_of, :jsonb, default: {}
    User.reset_column_information
    admins.each do |id, spaces|
      u = User.find(id)
      u.admin_of = spaces.reduce({}) {|hash, space| hash[space[:space_id]] = space[:name]; hash }
      u.save validate: false
    end
  end
end
