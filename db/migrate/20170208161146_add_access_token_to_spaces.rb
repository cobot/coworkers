class AddAccessTokenToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :access_token, :string
  end
end
