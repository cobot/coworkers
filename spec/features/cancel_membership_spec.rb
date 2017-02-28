require 'spec_helper'

describe 'cancel membership', type: :request do
  include Capybara::DSL

  before(:each) do
    stub_cobot_admin 'co.up', 'joe'
    visit new_session_path
    @space = Space.first
  end

  it 'sets up a cancellation webhook when adding a space' do
    expect(a_request(:post, 'https://co-up.cobot.me/api/subscriptions')
      .with(body: {event: 'canceled_membership',
                   callback_url: "http://www.example.com/spaces/#{@space.webhook_secret}/member_cancellation_webhook"},
            headers: {'Authorization' => 'Bearer test_token'}))
      .to have_been_made
  end

  it 'hides canceled members' do
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/m1')
      .to_return(body: {id: 'm1', canceled_to: '2016/10/01'}.to_json)

    @space.memberships.create! cobot_id: 'm1', name: 'jane dane', public: true

    post space_member_cancellation_webhook_path(@space.webhook_secret),
      url: 'https://co-up.cobot.me/api/memberships/m1'

    Timecop.travel Date.parse('2016-09-30') do
      visit space_memberships_path(@space)

      expect(page).to have_content('jane dane')
    end

    Timecop.travel Date.parse('2016-10-01') do
      visit space_memberships_path(@space)

      expect(page).to have_no_content('jane dane')
    end
  end

  it 'hides deleted members' do
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/m1')
      .to_return(status: 404, body: {}.to_json)
    @space.memberships.create! cobot_id: 'm1', name: 'jane dane'

    post space_member_cancellation_webhook_path(@space.webhook_secret),
      url: 'https://co-up.cobot.me/api/memberships/m1'

    visit space_memberships_path(@space)

    expect(page).to have_no_content('jane dane')
  end
end
