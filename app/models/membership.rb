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

  def self.create_from_cobot(cobot_membership, space, attributes = {})
    create attributes.merge(cobot_id: cobot_membership[:id],
      space_id: space.id,
      messenger_account: cobot_membership[:email],
      messenger_type: 'Email',
      name: cobot_membership[:name])
  end
end
