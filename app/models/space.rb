require 'securerandom'

class Space < ActiveRecord::Base
  has_many :message_boards
  has_many :memberships
  has_many :messages
  has_many :questions

  before_create :set_secret, :set_subdomain

  scope :by_subdomain, ->(subdomain) { where(subdomain: subdomain) }

  def to_param
    subdomain
  end

  def new_memberships
    @new_memberships ||= memberships.limit(3).order('memberships.created_at DESC')
  end

  def member?(user)
    user && Membership.by_space_id_and_user_id(id, user.id).first
  end
  alias_method :membership_for, :member?

  def updatable_by?(user)
    user.admin_of?(self)
  end

  def viewable_by?(user)
    !members_only? || member?(user) || (user && user.admin_of?(self))
  end

  private

  def set_subdomain
    self.subdomain = URI.parse(cobot_url).host.split('.').first if cobot_url?
  end

  def set_secret
    self.secret = SecureRandom.urlsafe_base64
  end
end
