When /^I add my website "([^"]*)" to my profile$/ do |website|
  visit account_path
  click_link 'Edit Profile'
  fill_in 'Website', with: website
  click_button 'Update Profile'
end

When /^I fill in my profile info$/ do
  fill_in 'Bio', with: 'i work all the time'
  click_button 'Update Profile'
end

Then /^"([^"]*)" should have listed the website "([^"]*)" on his "([^"]*)" profile$/ do |name, website, space_name|
  visit account_path
  click_link name
  page.should have_css('.website', text: website)
end
