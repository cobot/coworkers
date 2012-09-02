require 'spec_helper'

describe 'importing members as admins' do
  before(:each) do
    DatabaseCleaner.clean
  end

  it 'imports the data from cobot' do
    stub_cobot_admin 'co.up', 'joe'
    stub_cobot_membership 'co.up', 'Jane'
    sign_in
    space = space_by_name('co.up')
    click_link 'Members'
    click_link 'Import Members'
    check 'Jane'
    click_button 'Import Members'

    visit space_memberships_path(space)

    page.should have_content('Jane')
  end

  it 'imports the picture of a member with a user'
end
