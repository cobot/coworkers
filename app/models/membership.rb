class Membership < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :space
  validates_uniqueness_of :cobot_id, on: :create, scope: :space_id

  scope :by_space_id_and_user_id, ->(space_id, user_id) { where(space_id: space_id, user_id: user_id) }
  scope :active, ->() { where('memberships.canceled_to IS NULL or memberships.canceled_to > ?', Date.current) }
  scope :published, ->() { where(public: true) }

  def profile_completed?
    bio?
  end

  def last_name
    name.to_s.split(' ').last
  end

  def picture
    "https://#{space.subdomain}.cobot.me/api/memberships/#{cobot_id}/picture"
  end
end
