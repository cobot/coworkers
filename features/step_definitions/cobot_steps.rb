Before do
  WebMock.stub_request(:post, "https://www.cobot.me/oauth2/access_token").to_return(body: {access_token: '1'}.to_json, headers: {'Content-Type' => 'application/json'})
end

Given /^on cobot I'm a member of the space "([^"]+)" with the name "([^"]+)"(?: and email "([^"]+)")?(?: and id "([^"]*)")?$/ do |space_name, member_name, member_email, cobot_id|
  space_id = space_name.gsub(/\W+/, '-')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user').to_return(body: {
    id: cobot_id || 'user-alex',
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    admin_of: [], email: member_email || 'joe@doe.com'
  }.to_json, headers: {'Content-Type' => 'application/json'})

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json, headers: {'Content-Type' => 'application/json'})

  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}").to_return(body: {
    id: member_name.gsub(/\W+/, '-'),
    address: {
      name: member_name
    },
    confirmed_at: '2010-01-01'
  }.to_json, headers: {'Content-Type' => 'application/json'})
end

Given /^on cobot I'm a member of the space "([^"]+)" with email "([^"]+)" and name "([^"]+)"$/ do |space_name, email, member_name|
  space_id = space_name.gsub(/\W+/, '-')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user').to_return(body: {
    id: 'user-alex',
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    admin_of: [], email: email
  }.to_json, headers: {'Content-Type' => 'application/json'})

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json, headers: {'Content-Type' => 'application/json'})

  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}").to_return(body: {
    id: email.gsub(/\W+/, '-'),
    address: {
      name: member_name
    },
    confirmed_at: '2010-01-01'
  }.to_json, headers: {'Content-Type' => 'application/json'})
end


Given /^on cobot I'm an admin of the space "([^"]*)"(?: with the name "([^"]*)")?$/ do |space_name, name|
  space_id = space_name.gsub(/\W+/, '-')
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user').to_return(body: {
    id: 'user-alex',
    memberships: [],
    admin_of: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        name: name || 'joe'
      }
    ],
    email: 'joe@cobot.me'
  }.to_json, headers: {'Content-Type' => 'application/json'})

  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json, headers: {'Content-Type' => 'application/json'})
end
