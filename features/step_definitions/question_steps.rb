When /^I add the question "([^"]*)" to "([^"]*)"$/ do |question, space_name|
  visit account_path
  find('.space a').click
  click_link 'Settings'
  fill_in 'Text', with: question
  click_button 'Add Field'
end

When /^I answer the question with "([^"]*)"$/ do |answer|
  visit account_path
  find('.space a').click
  click_link 'Edit Profile'
  fill_in 'answers_0_text', with: answer
  click_button 'Update Profile'
end

Then /^the question "([^"]*)" with the answer "([^"]*)" should be listed on "([^"]*)"'s profile$/ do |question, answer, name|
  visit account_path
  find('.space a').click
  click_link name
  page.should have_css('.question', text: question)
  page.should have_css('.answer', text: answer)
end
