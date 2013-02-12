require 'spec_helper'

describe 'editing members as admin' do
  before(:each) do
    DatabaseCleaner.clean
    stub_user '1', {id: '1', memberships: [{space_subdomain: "co-up",
      space_link: "https://www.cobot.me/api/spaces/co-up",
      link: "https://co-up.cobot.me/api/memberships/mem-1" }]}
    stub_cobot_membership 'co.up', 'joe', 'mem-1'
    stub_space 'co-up', 'co.up'
    sign_in
    @space = space_by_name 'co.up'
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
  end

  it "lets me edit my basic details" do
    click_link 'My Profile'
    within('.action-links') { click_link 'Edit' }
    fill_in 'Profession', with: 'Senor Programmer'
    click_button 'Update Profile'
    click_link 'Members'

    page.should have_content('Senor Programmer')
  end

  it "lets me edit my custom details" do
    DB.save! Question.new(text: 'Hobbies', space_id: @space.id, type: 'short_text')

    click_link 'My Profile'
    within('.action-links') { click_link 'Edit' }
    fill_in 'Hobbies', with: 'sailing'
    click_button 'Update Profile'

    visit space_membership_path(@space, @space.memberships.first)
    expect(page).to have_content('sailing')
  end
end
