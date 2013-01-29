require 'spec_helper'

describe 'logging in' do
  before(:each) do
    DatabaseCleaner.clean
  end

  it 'redirects to the originally requested page' do
    stub_cobot_admin 'co.up', 'joe'
    space = Space.new name: 'co.up', cobot_url: 'http://co-up.cobot.me'
    DB.save! space
    user = User.new
    DB.save! user

    visit space_memberships_path(space, embed: true)

    expect(current_url).to eql(space_memberships_url(space, embed: true))
  end

  it 'logs me out and in if the user id from the cobot iframe does not match' do
    stub_cobot_admin 'co.up', 'joe', id: 'user-joe', email: 'joe@doe.com'
    visit authenticate_path # log in as joe

    stub_cobot_admin 'co.up', 'jane', id: 'user-jane', email: 'jane@doe.com'

    visit space_memberships_path(last_space, cobot_embed: true, cobot_user_id: 'user-jane')
    visit user_info_path

    expect(page.body).to eql('user-jane')
  end

end
