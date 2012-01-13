Given /^I am signed in as the admin of "([^"]*)"$/ do |space_name|
  Given %Q{on cobot I'm an admin of the space "#{space_name}"}
  When 'I sign in'
end

When /^I sign in$/ do
  visit root_url
  click_link 'Sign in'
end

When /^I sign as another user$/ do
  Given %Q{on cobot I'm an admin of the space "other-space"}
  When 'I sign out'
  When 'I sign in'
end

When /^I sign out$/ do
  click_link 'Sign out'
end
