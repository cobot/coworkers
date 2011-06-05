Before do
  WebMock.stub_request(:post, "https://www.cobot.me/oauth2/access_token").to_return(body: "{}")
end

Given /^on cobot I'm a member of the space "([^"]+)" with the name "([^"]+)"$/ do |space_name, member_name|
  space_id = space_name.gsub(/\W+/, '_')
  membership_id = next_id
  WebMock.stub_request(:get, 'https://www.cobot.me/api/user?oauth_token=').to_return(body: {
    memberships: [
      {
        space_url: "https://www.cobot.me/api/spaces/#{space_id}",
        url: "https://#{space_id}.cobot.me/api/memberships/#{membership_id}"
      }
    ]
  }.to_json)
  
  WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}?oauth_token=").to_return(body: {
    name: space_name,
    id: space_id
  }.to_json)
  
  WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}?oauth_token=").to_return(body: {
    address: {
      name: member_name
    }
  }.to_json)
end