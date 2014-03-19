module CobotHelpers
  def stub_user_membership(subdomain: raise, membership_id: 'membership-1')
    auth_mock({id: 'user-joe', memberships: [{space_subdomain: subdomain,
      space_link: "https://www.cobot.me/api/spaces/#{subdomain}",
      link: "https://#{subdomain}.cobot.me/api/memberships/#{membership_id}" }]})

    stub_cobot_membership subdomain, 'jane', membership_id
  end

  def stub_cobot_space_customization(attributes = {})
    stub_request(:get, "https://#{attributes.fetch(:subdomain)}.cobot.me/api/customization").to_return(
      body: {fonts: {}, general: {}, buttons: {}}.merge(attributes).to_json)
  end
end
