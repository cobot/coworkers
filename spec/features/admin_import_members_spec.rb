require 'spec_helper'

describe 'importing members as admins' do
  before(:each) do
    DatabaseCleaner.clean_with :truncation
  end

  it 'imports the data from cobot' do
    stub_cobot_admin 'co.up', 'joe'
    stub_cobot_membership 'co.up', 'Jane'
    sign_in
    space = space_by_name('co.up')
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    click_link 'Set up Profiles'
    check 'Jane'
    click_button 'Create Member Profiles'

    visit space_memberships_path(space)
    page.should have_content('Jane')
  end

  it 'imports the picture of a member with a user' do
    stub_cobot_admin 'co.up', 'joe'
    stub_cobot_membership 'co.up', 'Jane', nil, user: {email: 'jane@doe.com'}, picture: 'http://cobot.me/jane.jpg'
    sign_in
    space = space_by_name('co.up')
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    click_link 'Set up Profiles'
    check 'Jane'
    click_button 'Create Member Profiles'

    visit space_memberships_path(space)

    page.should have_css("img[src='http://cobot.me/jane.jpg']")
  end
end
