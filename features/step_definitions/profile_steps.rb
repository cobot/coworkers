When /^I add my website "([^"]*)" to my profile$/ do |website|
  visit account_path
  find('.space a').click
  click_link 'Edit Profile'
  fill_in 'Website', with: website
  fill_in 'Bio', with: '-'
  click_button 'Update Profile'
end

When 'I complete my profile' do
  visit account_path
  find('.space a').click
  click_link 'Set up Profile'
  fill_in 'Bio', with: '-'
  click_button 'Update Profile'
end

When /^I fill in my profile info$/ do
  click_link 'Set up Profile'
  fill_in 'Bio', with: 'i work all the time'
  click_button 'Update Profile'
end

Then /^"([^"]*)" should have listed the website "([^"]*)" on his "([^"]*)" profile$/ do |name, website, space_name|
  visit account_path
  find('.space a').click
  click_link name, match: :first
  page.should have_css('.website', text: website)
end
