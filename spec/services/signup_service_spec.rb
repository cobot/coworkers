require 'spec_helper'

describe SignupService, '#run' do
  let(:cobot_client) { double(:cobot_client) }

  before(:each) do
    allow(Space).to receive_messages(where: [])
    allow(User).to receive_messages(where: [])
    allow(User).to receive_messages(new: double(:user).as_null_object)
    allow(Membership).to receive_messages(where: [])
    allow(Membership).to receive_messages(create: double.as_null_object)
    allow(CobotClient::ApiClient).to receive(:new) { cobot_client }

    allow(cobot_client).to receive(:get).with('https://some-space.cobot.me/api/memberships/some-membership') {
      {confirmed_at: '2013-01-01 12:00', address: {}}
    }

    allow(cobot_client).to receive(:get).with('https://www.cobot.me/api/spaces/some-space') {
      {
        name: 'Some Space',
        id: 'space-some-space',
        url: 'https://some-space.cobot.me',
        subdomain: 'some-space'
      }
    }

    allow(cobot_client).to receive(:post)
      .with('www', '/access_tokens/token-1/space',
        space_id: 'space-some-space') { {token: 'space-token-some-space'} }
  end

  it 'does not creates a space for a member (no way to get a space access token as member. only admins can set up new spaces)' do
    attributes = {
      id: 'user-langalex',
      memberships: [
        {
          space_subdomain: 'some-space',
          space_name: 'Some Space',
          space_link: 'https://www.cobot.me/api/spaces/some-space',
          link: 'https://some-space.cobot.me/api/memberships/some-membership'
        }
      ],
      admin_of: []
    }

    expect(Space).to_not receive(:create)

    SignupService.new(attributes, 'token-1', nil).run
  end

  it 'creates a space for an admin' do
    allow(cobot_client).to receive(:post).with(anything, '/subscriptions', anything)
    attributes = {
      id: 'user-langalex',
      memberships: [],
      admin_of: [
        {
          space_subdomain: 'some-space',
          space_name: 'Some Space',
          space_link: 'https://www.cobot.me/api/spaces/some-space',
          link: 'https://some-space.cobot.me/api/memberships/some-membership'
        }
      ]
    }

    expect(Space).to receive(:create).with(name: 'Some Space', cobot_id: 'space-some-space',
      cobot_url: 'https://some-space.cobot.me',
      access_token: 'space-token-some-space') { double.as_null_object }

    SignupService.new(attributes, 'token-1', double(:routes).as_null_object).run
  end
end
