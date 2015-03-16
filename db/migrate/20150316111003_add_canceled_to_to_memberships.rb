class AddCanceledToToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :canceled_to, :date
  end
end
