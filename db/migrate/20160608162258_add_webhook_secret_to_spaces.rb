class AddWebhookSecretToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :webhook_secret, :string
    add_index :spaces, :webhook_secret
  end
end
