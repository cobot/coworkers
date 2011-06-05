Given /^a space "([^"]*)"$/ do |name|
  DB.save! Space.new(name: name, id: name.gsub(/\W+/, '_'))
end

Then /^I should have "([^"]*)" in my list of spaces$/ do |space_name|
  visit account_path
  page.should have_css('.space', text: space_name)
end