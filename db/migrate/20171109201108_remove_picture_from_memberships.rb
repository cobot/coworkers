class RemovePictureFromMemberships < ActiveRecord::Migration
  def change
    remove_column :memberships, :picture, :string
  end
end
