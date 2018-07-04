require 'spec_helper'

describe 'managing questions' do
  before(:each) do
    stub_cobot_admin 'co.up'
    sign_in
    visit space_questions_path(space_by_name('co.up'))
  end

  it 'adds questions' do
    add_question 'What can you contribute?'

    expect(page).to have_content('What can you contribute?')
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

  def add_question(text)
    fill_in 'Text', with: text
    click_button 'Add Field'
  end
end
