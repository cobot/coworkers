Before do
  WebMock.stub_request(:post, "https://www.cobot.me/oauth2/access_token").to_return(body: "{}")
end

Given /^on cobot I'm a member of the space "([^"]+)" with the name "([^"]+)"(?: and email "([^"]+)")?$/ do |space_name, member_name, member_email|
  space_id = space_name.gsub(/\W+/, '_')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    admin_of: [], email: member_email || 'joe@doe.com'
  }.to_json)

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)

  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}?oauth_token=").to_return(body: {
    id: member_name.gsub(/\W+/, '_'),
    address: {
      name: member_name
    },
    confirmed_at: '2010-01-01'
  }.to_json)
end

Given /^on cobot I'm a member of the space "([^"]+)" with email "([^"]+)" and name "([^"]+)"$/ do |space_name, email, member_name|
  space_id = space_name.gsub(/\W+/, '_')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    admin_of: [], email: email
  }.to_json)

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)

  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}?oauth_token=").to_return(body: {
    id: email.gsub(/\W+/, '_'),
    address: {
      name: member_name
    },
    confirmed_at: '2010-01-01'
  }.to_json)
end


Given /^on cobot I'm an admin of the space "([^"]*)"(?: with the name "([^"]*)")?$/ do |space_name, name|
  space_id = space_name.gsub(/\W+/, '_')
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [],
    admin_of: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        name: name || 'joe'
      }
    ],
    email: 'joe@cobot.me'
  }.to_json)

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)
end
