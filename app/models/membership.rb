class Membership < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  belongs_to :space

  scope :by_space_id_and_user_id, ->(space_id, user_id) {where(space_id: space_id, user_id: user_id)}

  def profile_completed?
    bio?
  end

  def last_name
    name.to_s.split(' ').last
  end
end
