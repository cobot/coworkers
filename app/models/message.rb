class Message < ActiveRecord::Base

  belongs_to :message_board
  belongs_to :author, class_name: 'User'
  belongs_to :space

  validates_presence_of :text

  def editable_by?(user, space)
    user && author_id == user.id || user.admin_of?(space)
  end
end
