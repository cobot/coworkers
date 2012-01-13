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
