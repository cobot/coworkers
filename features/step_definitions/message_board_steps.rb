When /^I add a message board "([^"]*)"$/ do |name|
  visit account_path
  click_link 'Message Boards'
  click_link 'Add one'
  fill_in 'Name', with: name
  click_button 'Add Message Board'
end

Then /^"([^"]*)" should have a "([^"]*)" board$/ do |space_name, board_name|
  space = space_by_name(space_name)
  visit url_for(space)
  click_link 'Message Board'
  page.should have_css('*', text: board_name)
end

Given /^"([^"]*)" has a "([^"]*)" board$/ do |space_name, board_name|
  space = space_by_name space_name
  DB.save! MessageBoard.new(space_id: space.id, name: board_name)
end

When /^I remove the "([^"]*)" board$/ do |board_name|
  visit account_path
  click_link 'Message Board'
  click_link board_name
  click_link "Remove Message Board"
end

When /^I post a message "([^"]*)" on the "([^"]*)" board$/ do |text, board_name|
  visit account_path
  click_link 'Message Board'
  click_link board_name
  fill_in 'Text', with: text
  click_button 'Post Message'
end

Then /^the "([^"]*)" board should have a message "([^"]*)"$/ do |board_name, message|
  visit account_path
  click_link 'Message Board'
  click_link board_name
  page.should have_css('*', text: message)
end

Then /^"([^"]*)" should have no "([^"]*)" board$/ do |space_name, board_name|
  space = space_by_name(space_name)
  visit url_for(space)
  click_link 'Message Board'
  page.should have_no_css('*', text: board_name)
end
