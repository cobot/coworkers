require 'securerandom'

class Space < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :questions, dependent: :destroy

  before_create :set_secrets, :set_subdomain

  scope :by_cobot_id, ->(cobot_id) { where(cobot_id: cobot_id) }

  def to_param
    cobot_id
  end

  def new_memberships
    @new_memberships ||= memberships.active.published.limit(3).order('memberships.created_at DESC')
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

  def set_secrets
    self.secret = SecureRandom.urlsafe_base64
    self.webhook_secret = SecureRandom.urlsafe_base64
  end
end
