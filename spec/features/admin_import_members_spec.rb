require 'spec_helper'

describe 'importing members as admins' do
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
end
