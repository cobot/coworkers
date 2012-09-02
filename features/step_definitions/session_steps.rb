Given /^I am signed in as the admin of "([^"]*)"$/ do |space_name|
  step %Q{on cobot I'm an admin of the space "#{space_name}"}
  step 'I sign in'
end

When /^I sign in$/ do
  visit root_url
  click_link 'Sign in'
  if current_path == edit_account_path
    fill_in 'Bio', with: 'i work here'
    click_button 'Update Profile'
  end
end

When /^I sign as another user$/ do
  step %Q{on cobot I'm an admin of the space "other-space"}
  step 'I sign out'
  step 'I sign in'
end

When /^I sign out$/ do
  click_link 'Sign out'
end
