require 'digest/md5'

module UserHelper
  
  def user_image_url(user, size = 50, secure = false)
    md5 = Digest::MD5.hexdigest(user.email)
    if secure
      "https://secure.gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
    else
      "http://gravatar.com/avatar/#{md5}?d=mm&size=#{size}"
    end
  end
  
end