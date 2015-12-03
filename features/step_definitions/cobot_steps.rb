Before do
  auth_mock
end

Given /^on cobot I'm a member of the space "([^"]+)" with the name "([^"]+)"(?: and email "([^"]+)")?(?: and id "([^"]*)")?$/ do |space_name, member_name, member_email, cobot_id|
  space_id = space_name.gsub(/\W+/, '-')
  membership_id = next_id
  auth_mock_raw_info["id"] = cobot_id || 'user-alex'
  auth_mock_raw_info["email"] = member_email || 'mail@cobot.me'
  auth_mock_raw_info["memberships"] = [
    {
      space_link: "https://www.cobot.me/api/spaces/#{space_id}",
      link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
    }
  ]
  stub_space(space_id, space_name)

  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}").to_return(
  headers: {'Content-Type' => 'application/json'},
  body: {
    id: member_name.gsub(/\W+/, '-'),
    name: member_name,
    confirmed_at: '2010-01-01'
  }.to_json)
end

Given /^on cobot I'm an admin of the space "([^"]*)"(?: with the name "([^"]*)")?$/ do |space_name, name|
  stub_cobot_admin(space_name, name)
end
