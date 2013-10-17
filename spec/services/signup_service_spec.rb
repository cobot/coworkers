require 'spec_helper'

describe SignupService, '#run' do
  let(:access_token) { stub(:access_token).as_null_object }

  before(:each) do
    Space.stub(where: [])
    User.stub(where: [])
    User.stub(new: stub(:user).as_null_object)
    Membership.stub(where: [])
    Membership.stub(create: stub.as_null_object)

    access_token.stub(:get).with('https://some-space.cobot.me/api/memberships/some-membership') {
      stub(parsed: {'confirmed_at' => '2013-01-01 12:00', 'address' => {}})
    }

    access_token.stub(:get).with('https://www.cobot.me/api/spaces/some-space') {
      stub(parsed: {
          "name" => "Some Space",
          "id" => "space-some-space",
          "url" => "https://some-space.cobot.me",
          "subdomain" => "some-space"
        }
      )
    }
  end

  it 'creates a space for a member' do
    attributes = {
      "id" => "user-langalex",
      "memberships" => [
        {
          "space_subdomain" => "some-space",
          "space_name" => "Some Space",
          "space_link" => "https://www.cobot.me/api/spaces/some-space",
          "link" => "https://some-space.cobot.me/api/memberships/some-membership"
        }
      ],
      "admin_of" => []
    }

    Space.should_receive(:create).with(name: 'Some Space', cobot_id: 'space-some-space',
      cobot_url: 'https://some-space.cobot.me') { stub.as_null_object }

    SignupService.new(attributes, access_token).run
  end

  it 'creates a space for an admin' do
    attributes = {
      "id" => "user-langalex",
      "memberships" => [
        {
          "space_subdomain" => "some-space",
          "space_name" => "Some Space",
          "space_link" => "https://www.cobot.me/api/spaces/some-space",
          "link" => "https://some-space.cobot.me/api/memberships/some-membership"
        }
      ],
      "admin_of" => []
    }

    Space.should_receive(:create).with(name: 'Some Space', cobot_id: 'space-some-space',
      cobot_url: 'https://some-space.cobot.me') { stub.as_null_object }

    SignupService.new(attributes, access_token).run
  end
end
