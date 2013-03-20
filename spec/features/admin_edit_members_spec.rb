require 'spec_helper'

describe 'editing members as admin' do
  before(:each) do
    DatabaseCleaner.clean_with :truncation
  end

  it "lets me edit a member's basic details" do
    stub_cobot_admin 'co.up', 'joe'

    sign_in

    space = space_by_name 'co.up'
    Membership.create!(name: 'Jane', space_id: space.id)
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click
    click_link 'Edit'
    fill_in 'Profession', with: 'Senor Programmer'
    click_button 'Update Profile'
    click_link 'Members'

    page.should have_content('Senor Programmer')
  end

  it "lets me edit a member's custom details" do
    stub_cobot_admin 'co.up', 'joe'
    sign_in
    space = space_by_name 'co.up'
    membership = Membership.create!(name: 'Jane', space_id: space.id)
    Question.create!(text: 'Hobbies', space_id: space.id, question_type: 'short_text')

    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click
    click_link 'Edit'
    fill_in 'Hobbies', with: 'sailing'
    click_button 'Update Profile'

    visit space_membership_path(space, membership)
    expect(page).to have_content('sailing')
  end

  it "lets me update a member's picture" do
    stub_cobot_admin 'co.up', 'joe'
    stub_cobot_membership 'co.up', nil, 'mem-1', picture: 'http://example.com/new_picture.jpg'
    sign_in
    space = space_by_name 'co.up'
    user = User.create! access_token: 'token-123'
    membership = Membership.create!(name: 'Jane', space_id: space.id, user_id: user.id, cobot_id: 'mem-1')

    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click
    click_link 'Edit'
    click_link 'Update Picture'

    visit space_membership_path(space, membership)
    expect(page).to have_css("img[src='http://example.com/new_picture.jpg']")
  end
end
