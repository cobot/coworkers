Given /^a space "([^"]*)"$/ do |name|
  DB.save! Space.new(name: name, id: name.gsub(/\W+/, '_'))
end

When /^I change the visibility to members only$/ do
  find('.space a:first').click
  click_link 'Settings'
  check 'Visible for Members only'
  click_button 'Save'
end

Then /^I should have "([^"]*)" in my list of spaces$/ do |space_name|
  visit account_path
  page.should have_css('.space', text: space_name)
end