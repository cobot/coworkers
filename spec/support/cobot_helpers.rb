module CobotHelpers
  def stub_user_membership(subdomain: raise, membership_id: 'membership-1')
    auth_mock({id: 'user-joe', memberships: [{space_subdomain: subdomain,
      space_link: "https://www.cobot.me/api/spaces/#{subdomain}",
      link: "https://#{subdomain}.cobot.me/api/memberships/#{membership_id}" }]})

    stub_cobot_membership subdomain, 'jane', membership_id
  end
end
