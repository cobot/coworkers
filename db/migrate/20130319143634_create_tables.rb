class CreateTables < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :question, :text
      t.belongs_to :membership, :question
      t.timestamps
    end
    add_index :answers, :membership_id
    add_index :answers, :question_id
    add_index :answers, :created_at

    create_table :memberships do |t|
      t.belongs_to :space, :user
      t.string :name, :website, :messenger_type,
        :messenger_account, :picture, :cobot_id
      t.text :bio, :profession, :industry, :skills
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :space_id
    add_index :memberships, :created_at

    create_table :messages do |t|
      t.text :text
      t.string :author_name
      t.belongs_to :author, :space, :message_board
      t.timestamps
    end
    add_index :messages, :message_board_id
    add_index :messages, :space_id

    create_table :message_boards do |t|
      t.string :name
      t.belongs_to :space
      t.timestamps
    end
    add_index :message_boards, :space_id

    create_table :questions do |t|
      t.text :text
      t.string :question_type
      t.belongs_to :space
      t.timestamps
    end
    add_index :questions, :space_id

    create_table :spaces do |t|
      t.string :name, :secret, :cobot_url, :cobot_id, :subdomain
      t.boolean :members_only
      t.timestamps
    end
    add_index :spaces, :name
    add_index :spaces, :subdomain

    create_table :users do |t|
      t.string :cobot_id, :email, :access_token
      t.text :admin_of
    end
    add_index :users, :email
    add_index :users, :cobot_id
  end

end
