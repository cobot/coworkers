require 'digest/md5'

module UserHelper
  
  def skype_url(user)
    "skype:#{user.messenger_account}?add"
  end
  
end