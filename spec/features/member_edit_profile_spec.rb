require 'spec_helper'

describe 'editing my own profile' do
  before(:each) do
    @space = Space.create subdomain: 'co-up', cobot_id: 'co-up', name: 'co.up'
    stub_user_membership subdomain: 'co-up', membership_id: 'mem-1'
    stub_cobot_membership 'co.up', 'joe', 'mem-1'
    stub_space 'co-up', 'co.up'
    sign_in
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
  end

  it 'lets me edit my basic details' do
    click_link 'My Profile'
    click_link 'Edit'
    fill_in 'Profession', with: 'Senor Programmer'
    check 'Publish Profile'
    click_button 'Update Profile'
    click_link 'Members'

    expect(page).to have_content('Senor Programmer')
  end

  it 'lets me edit my custom details' do
    Question.create!(text: 'Hobbies', space_id: @space.id, question_type: 'short_text')

    click_link 'My Profile'
    click_link 'Edit'
    fill_in 'Hobbies', with: 'sailing'
    click_button 'Update Profile'

    visit space_membership_path(@space, @space.memberships.first)
    expect(page).to have_content('sailing')
  end
end
