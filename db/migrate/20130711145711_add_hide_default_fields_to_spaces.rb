class AddHideDefaultFieldsToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :hide_default_fields, :boolean
  end
end
