module CobotApiHelpers
  def stub_cobot_admin(space_name, name, user_attributes = {})
    space_id = space_name.gsub(/\W+/, '-')
    WebMock.stub_request(:get, 'https://www.cobot.me/api/user').to_return(body: {
      id: user_attributes[:id] || 'user-alex',
      memberships: [],
      admin_of: [
        {
          space_link: "https://www.cobot.me/api/spaces/#{space_id}",
          name: name || 'joe'
        }
      ],
      email: user_attributes[:email] || 'joe@cobot.me'
    }.to_json, headers: {'Content-Type' => 'application/json'})

    WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}").to_return(body: {
      name: space_name,
      url: "https://#{space_id}.cobot.me",
      id: space_id
    }.to_json, headers: {'Content-Type' => 'application/json'})
  end

  def stub_user(access_token, attributes)
    WebMock.stub_request(:get, "https://www.cobot.me/api/user")
      .with(headers: {'Authorization' => "Bearer #{access_token}"})
      .to_return(
        body: attributes.to_json, headers: {'Content-Type' => 'application/json'})
  end

  def stub_cobot_membership(space_name, name, membership_id = nil, attributes = {})
    space_id = space_name.gsub(/\W+/, '-')
    membership_id ||= next_id
    WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships").to_return(body: [{
      id: membership_id,
      address: {
        name: name
      },
      confirmed_at: '2010-01-01'
    }.merge(attributes)].to_json, headers: {'Content-Type' => 'application/json'})

    WebMock.stub_request(:get, "https://#{space_id}.cobot.me/api/memberships/#{membership_id}").to_return(body: {
      id: membership_id,
      address: {
        name: name
      },
      confirmed_at: '2010-01-01'
    }.merge(attributes).to_json, headers: {'Content-Type' => 'application/json'})
  end
end

World(CobotApiHelpers) if respond_to?(:World)
