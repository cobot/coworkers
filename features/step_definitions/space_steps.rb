Given /^a space "([^"]*)"$/ do |name|
  Space.create!(name: name, cobot_id: name.gsub(/\W+/, '-'), subdomain: name.gsub(/\W+/, '-'))
end

When /^I change the visibility to members only$/ do
  click_link 'Settings'
  check 'Visible for Members only'
  click_button 'Save'
end

Then /^I should have "([^"]*)" in my list of spaces$/ do |space_name|
  visit account_path
  page.should have_css('.space', text: space_name)
end
