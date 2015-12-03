class RemoveMessageBoards < ActiveRecord::Migration
  def change
    drop_table :messages
    drop_table :message_boards
  end
end
