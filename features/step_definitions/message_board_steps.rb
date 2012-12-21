When /^I add a message board "([^"]*)"$/ do |name|
  visit account_path
  find('.space a').click
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

Given /^the "([^"]*)" board has a message with the text "([^"]*)"$/ do |board_name, text|
  board = DB.view(MessageBoard.by_space_id_and_id).find{|board| board.name == board_name}
  DB.save! Message.new(message_board_id: board.id, text: text, space_id: board.space_id)
end

Given /^the "([^"]*)" board has a message with a long text starting withh "([^"]*)" and ending with "([^"]*)"$/ do |board_name, text_start, text_end|
  board = DB.view(MessageBoard.by_space_id_and_id).find{|board| board.name == board_name}
  DB.save! Message.new(message_board_id: board.id, text: text_start + 'X' * 150 + text_end)
end

When /^I remove the "([^"]*)" board$/ do |board_name|
  visit account_path
  find('.space a').click
  click_link 'Message Board'
  click_link board_name
  click_link "Remove Message Board"
end

When /^I post a message "([^"]*)" on the "([^"]*)" board$/ do |text, board_name|
  visit account_path
  find('.space a').click
  click_link 'Message Board'
  click_link board_name
  fill_in 'Text', with: text
  click_button 'Post Message'
end

When /^I change the message on the "([^"]*)" board to "([^"]*)"$/ do |board_name, new_text|
  visit account_path
  find('.space a').click
  click_link 'Message Board'
  click_link board_name
  click_link 'Edit Message'
  fill_in 'Text', with: new_text
  click_button 'Update Message'
end

Then /^the "([^"]*)" board should have a message "([^"]*)"(?: by "([^"]*)")?$/ do |board_name, message, author_name|
  visit account_path
  find('.space a').click
  click_link 'Message Board'
  click_link board_name
  page.should have_css('*', text: message)
  page.should have_css('*', text: "by #{author_name}") if author_name
end

Then /^the "([^"]*)" board should have a message that starts with "([^"]*)"$/ do |board_name, message_start|
  visit account_path
  find('.space a').click
  click_link 'Message Board'
  click_link board_name
  page.should have_css('*', text: /^#{Regexp.escape message_start}/)
end

Then /^"([^"]*)" should have no "([^"]*)" board$/ do |space_name, board_name|
  space = space_by_name(space_name)
  visit url_for(space)
  click_link 'Message Board'
  page.should have_no_css('*', text: board_name)
end
