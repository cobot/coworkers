require 'digest/md5'

module UserHelper
  
  def user_image_url(user, size = 50, secure = request.ssl?)
    email = user.email
    if user.email.nil?
      email = "info@cobot.me"
    md5 = Digest::MD5.hexdigest(email)
    if secure
      "https://secure.gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
    else
      "http://gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
    end
  end
  
  def skype_url(user)
    "skype:#{user.messenger_account}?add"
  end
  
end