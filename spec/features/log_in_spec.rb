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
    click_link 'Sign In'

    expect(current_url).to eql(space_memberships_url(space, embed: true))
  end
end
