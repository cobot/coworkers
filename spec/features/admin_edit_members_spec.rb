require 'spec_helper'

describe 'editing members as admin' do
  it "lets me edit a member's basic details" do
    stub_cobot_admin 'co.up', 'joe'

    sign_in

    space = space_by_name 'co.up'
    Membership.create!(public: true, name: 'Jane', space_id: space.id)
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click
    click_link 'Edit'
    fill_in 'Profession', with: 'Senor Programmer'
    click_button 'Update Profile'
    click_link 'Members'
    first(:link, 'Jane').click

    expect(page).to have_content('Senor Programmer')
  end

  it 'lets me upload a photo' do
    update_picture = stub_request(:put, 'https://co-up.cobot.me/api/memberships/mem-1/picture')
                     .with(body: /base64/)
                     .to_return(body: '{}')
    stub_cobot_admin 'co.up', 'joe'
    sign_in
    space = space_by_name 'co.up'
    Membership.create!(public: true, name: 'Jane', space_id: space.id, cobot_id: 'mem-1')
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click

    click_link 'Edit'
    attach_file 'Picture', Rails.root.join('spec', 'fixtures', 'picture.png')

    click_button 'Update Profile'
    expect(update_picture).to have_been_made
  end

  it "lets me edit a member's custom details" do
    stub_cobot_admin 'co.up', 'joe'
    sign_in
    space = space_by_name 'co.up'
    membership = Membership.create!(public: true, name: 'Jane', space_id: space.id)
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

  it 'lets admins edit unpublished profiles' do
    stub_cobot_admin 'co.up', 'joe'

    sign_in

    space = space_by_name 'co.up'
    Membership.create!(public: false, name: 'Jane', space_id: space.id)
    click_link 'co.up'
    within('#menu') { click_link 'Members' }
    first(:link, 'Jane').click
    click_link 'Edit'
    fill_in 'Name', with: 'Jane Doe'
    click_button 'Update Profile'

    expect(page).to have_content('Jane Doe')
  end
end
