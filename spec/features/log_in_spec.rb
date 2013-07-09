require 'spec_helper'

describe 'logging in' do
  before(:each) do
    DatabaseCleaner.clean_with :truncation
  end

  it 'redirects to the originally requested page' do
    stub_cobot_admin 'co.up', 'joe'
    space = Space.create! name: 'co.up', cobot_url: 'http://co-up.cobot.me',
      cobot_id: 'space-co-up'
    user = User.create!

    visit space_memberships_path(space, embed: true)

    expect(current_url).to eql(space_memberships_url(space, embed: true))
  end

  it 'logs me out and in if the user id from the cobot iframe does not match' do
    stub_cobot_admin 'co.up', 'joe', id: 'user-joe', email: 'joe@doe.com'
    visit new_session_path # log in as joe

    stub_cobot_admin 'co.up', 'jane', id: 'user-jane', email: 'jane@doe.com'

    visit space_memberships_path(last_space, cobot_embed: true, cobot_user_id: 'user-jane')
    visit user_info_path

    expect(page.body).to eql('user-jane')
  end

  it 'connects the memberships already imported before to a newly created user account' do
    stub_cobot_membership 'co-up', 'joe', 'mem-123'
    auth_mock_raw_info["memberships"] = [
      {
        space_link: "https://www.cobot.me/api/spaces/co-up",
        link: "https://co-up.cobot.me/api/memberships/mem-123"
      }
    ]
    space = Space.create! name: 'co.up', cobot_url: 'http://co-up.cobot.me', cobot_id: 'space-co-up'
    space.memberships.create! cobot_id: 'mem-123'

    visit new_session_path

    expect(page).to have_content('co.up')
  end
end
