require 'securerandom'

class Space
  include CouchPotato::Persistence

  property :name
  property :members_only, type: :boolean
  property :secret

  view :by_id, key: :_id
  view :by_name, key: :name

  before_create :set_secret

  def message_boards
    database.view(MessageBoard.by_space_id_and_name(startkey: [id], endkey: [id, {}]))
  end

  def memberships
    @memberships ||= database.view(Membership.by_space_id(id)).sort_by(&:last_name)
  end

  def questions
    @questions ||= database.view(Question.by_space_id(id))
  end

  def member?(user)
    user && database.first(Membership.by_space_id_and_user_id([id, user.id]))
  end
  alias_method :membership_for, :member?

  def updatable_by?(user)
    user.admin_of?(self)
  end

  def viewable_by?(user)
    !members_only? || member?(user) || (user && user.admin_of?(self))
  end

  private

  def set_secret
    self.secret = SecureRandom.urlsafe_base64
  end
end
