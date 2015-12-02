require 'spec_helper'

describe SignupService, '#run' do
  let(:access_token) { double(:access_token).as_null_object }

  before(:each) do
    allow(Space).to receive_messages(where: [])
    allow(User).to receive_messages(where: [])
    allow(User).to receive_messages(new: double(:user).as_null_object)
    allow(Membership).to receive_messages(where: [])
    allow(Membership).to receive_messages(create: double.as_null_object)

    allow(access_token).to receive(:get).with('https://some-space.cobot.me/api/memberships/some-membership') {
      double(parsed: {'confirmed_at' => '2013-01-01 12:00', 'address' => {}})
    }

    allow(access_token).to receive(:get).with('https://www.cobot.me/api/spaces/some-space') {
      double(parsed: {
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

    expect(Space).to receive(:create).with(name: 'Some Space', cobot_id: 'space-some-space',
      cobot_url: 'https://some-space.cobot.me') { double.as_null_object }

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

    expect(Space).to receive(:create).with(name: 'Some Space', cobot_id: 'space-some-space',
      cobot_url: 'https://some-space.cobot.me') { double.as_null_object }

    SignupService.new(attributes, access_token).run
  end
end
