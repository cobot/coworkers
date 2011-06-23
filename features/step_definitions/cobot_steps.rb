Before do
  WebMock.stub_request(:post, "https://www.cobot.me/oauth2/access_token").to_return(body: "{}")
end

Given /^on cobot I'm a member of the space "([^"]+)" with the name "([^"]+)" and email "([^"]+)"$/ do |space_name, member_name, member_email|
  space_id = space_name.gsub(/\W+/, '_')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    login: member_name, admin_of: [], email: member_email 
  }.to_json)
  
  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)
  
  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}?oauth_token=").to_return(body: {
    id: member_name.gsub(/\W+/, '_'),
    address: {
      name: member_name,
    },
    confirmed_at: '2010-01-01'
  }.to_json)
end

Given /^on cobot my space "([^"]+)" has the following members:/ do |space_id, fields|
  members = []
  fields.rows.each do |login, email, name|
    members << {
      id: '1',
      user: {
        login: login,
        email: email
      },
      address: {
        name: name
      },
      confirmed_at: 1.week.ago,
      canceled_to: nil
    }
  end
  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships?oauth_token=").to_return(body: members.to_json)
end

Given /^on cobot I'm a member of the space "([^"]+)" with login "([^"]+)" and name "([^"]+)"$/ do |space_name, login, member_name|
  space_id = space_name.gsub(/\W+/, '_')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}",
        link: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ],
    login: login, admin_of: [], email: "#{login}@cobot.me" 
  }.to_json)
  
  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)
  
  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}?oauth_token=").to_return(body: {
    id: login.gsub(/\W+/, '_'),
    address: {
      name: member_name
    },
    confirmed_at: '2010-01-01'
  }.to_json)
end


Given /^on cobot I'm an admin of the space "([^"]*)"$/ do |space_name|
  space_id = space_name.gsub(/\W+/, '_')
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [],
    admin_of: [
      {
        space_link: "https://www.cobot.me/api/spaces/#{space_id}"
      }
    ],
    login: 'joe', email: 'joe@cobot.me'
  }.to_json)
  
  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)
end