require 'spec_helper'

describe 'managing questions' do
  before(:each) do
    stub_cobot_admin 'co.up'
    sign_in
    click_link 'co.up'
    click_link 'Settings'
  end

  it 'adds questions' do
    add_question 'What can you contribute?'
    stub_user_membership subdomain: 'co-up'
    sign_in
    set_up_membership_profile
    answer_question 'What can you contribute?', with: 'i can cook'
    visit space_membership_path(Space.last, Membership.last)

    expect(page).to have_content('What can you contribute?')
    expect(page).to have_content('i can cook')
  end

  it 'updates questions' do
    add_question 'What can you contribute?'
    click_link 'Edit'
    fill_in 'Text', with: 'What will you contribute?'
    click_button 'Update field'

    expect(page).to have_no_content('What can you contribute?')
    expect(page).to have_content('What will you contribute?')
  end

  it 'removes questions' do
    add_question 'What can you contribute?'
    click_link 'Remove'

    expect(page).to have_no_content('What can you contribute?')
  end

  def answer_question(_text, with: raise)
    visit account_path
    find('.space a').click
    click_link 'Edit Profile'
    fill_in 'answers_0_text', with: with
    click_button 'Update Profile'
  end

  def add_question(text)
    fill_in 'Text', with: text
    click_button 'Add Field'
  end
end
