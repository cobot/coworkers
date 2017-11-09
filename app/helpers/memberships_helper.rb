module MembershipsHelper
  def format_messenger(type, account)
    case type
    when 'Skype'
      link_to account, "skype:#{account}?add", target: '_blank'
    when 'Twitter'
      name = account.sub('@', '')
      link_to "@#{name}", "http://twitter.com/#{name}", target: '_blank'
    when 'Phone'
      link_to account, "tel:#{account.to_s.gsub(/\s+/, '')}"
    when 'Email'
      mail_to account, account
    else
      account
    end
  end
end
