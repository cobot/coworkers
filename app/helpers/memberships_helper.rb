module MembershipsHelper
  def format_messenger(type, account)
    case type
    when 'Skype'
      link_to account, "skype:#{account}?add"
    when 'Twitter'
      name = account.sub('@', '')
      link_to "@#{name}", "http://twitter.com/#{name}"
    else
      account
    end
  end
end
