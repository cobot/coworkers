class RemoveUserAccessTokens < ActiveRecord::Migration
  def change
    remove_column :users, :access_token, :string
  end
end
