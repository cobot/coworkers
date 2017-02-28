class AddPublicToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :public, :boolean, default: false
    execute 'UPDATE memberships SET public=true'
  end
end
