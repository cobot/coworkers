module CobotApiHelpers
  def auth_mock(user_attributes = {})
    # unless @auth_mock
      @auth_mock = OmniAuth.config.mock_auth[:cobot] = {}
      OmniAuth.config.mock_auth[:cobot]["extra"] = {
        raw_info:{
          id: 'user-alex',
          admin_of: [],
          memberships: [],
          email: "email@cobot.me"
        }.merge(user_attributes)
      }.with_indifferent_access
      OmniAuth.config.mock_auth[:cobot]["credentials"] = {"token" => "test_token"}
    # end
    @auth_mock
  end

  def auth_mock_raw_info
    auth_mock['extra']['raw_info']
  end

  def reset_auth
    @auth_mock = nil
  end

  def stub_cobot_admin(space_name, name = 'joe', user_attributes = {})
    space_id = space_name.gsub(/\W+/, '-')
    raw_info = auth_mock_raw_info
    raw_info.merge!(user_attributes.with_indifferent_access)
    raw_info['admin_of'] = [space_link: "https://www.cobot.me/api/spaces/#{space_id}", name: name]
    stub_space(space_id, space_name)
  end

  def stub_space(space_id, space_name)
    WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{space_id}").to_return(body: {
      name: space_name,
      url: "https://#{space_id}.cobot.me",
      id: space_id
    }.to_json, headers: {'Content-Type' => 'application/json'})
  end

  def stub_user(access_token = '123', attributes = {})
    WebMock.stub_request(:get, "https://www.cobot.me/api/user")
      .with(headers: {'Authorization' => "Bearer #{access_token}"})
      .to_return(
        body: {admin_of: []}.merge(attributes).to_json,
        headers: {'Content-Type' => 'application/json'})
  end

  def stub_cobot_membership(space_name, name = 'jane', membership_id = nil, attributes = {})
    subdomain = space_name.gsub(/\W+/, '-')
    membership_id ||= next_id
    WebMock.stub_request(:get, "https://#{subdomain}.cobot.me/api/memberships").to_return(body: [{
      id: membership_id,
      address: {
        name: name
      },
      confirmed_at: '2010-01-01'
    }.merge(attributes)].to_json, headers: {'Content-Type' => 'application/json'})

    WebMock.stub_request(:get, "https://#{subdomain}.cobot.me/api/memberships/#{membership_id}").to_return(body: {
      id: membership_id,
      address: {
        name: name
      },
      confirmed_at: '2010-01-01'
    }.merge(attributes).to_json, headers: {'Content-Type' => 'application/json'})
  end
end

World(CobotApiHelpers) if respond_to?(:World)
