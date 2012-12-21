require 'spec_helper'

describe 'editing members as admin' do
  before(:each) do
    DatabaseCleaner.clean
  end

  it "lets me edit a member's basic details" do
    stub_cobot_admin 'co.up', 'joe'
    sign_in
    space = space_by_name 'co.up'
    DB.save! Membership.new(name: 'Jane', space_id: space.id)
    click_link 'co.up'
    click_link 'Members'
    click_link 'Jane'
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
    membership = Membership.new(name: 'Jane', space_id: space.id)
    DB.save! membership
    DB.save! Question.new(text: 'Hobbies', space_id: space.id, type: 'short_text')

    click_link 'co.up'
    click_link 'Members'
    click_link 'Jane'
    click_link 'Edit'
    fill_in 'Hobbies', with: 'sailing'
    click_button 'Update Profile'

    visit space_membership_path(space, membership)
    expect(page).to have_content('sailing')
  end

  it "lets me update a member's picture" do
    stub_cobot_admin 'co.up', 'joe'
    stub_user 'token-123', picture: 'http://example.com/new_picture.jpg'
    sign_in
    space = space_by_name 'co.up'
    user = User.new access_token: 'token-123'
    DB.save! user
    membership = Membership.new(name: 'Jane', space_id: space.id, user_id: user.id)
    DB.save! membership

    click_link 'co.up'
    click_link 'Members'
    click_link 'Jane'
    click_link 'Edit'
    click_link 'Update Picture'

    visit space_membership_path(space, membership)
    expect(page).to have_css("img[src='http://example.com/new_picture.jpg']")
  end
end
