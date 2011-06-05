Then /^"([^"]+)" should be listed as a member of the space "([^"]+)"$/ do |membership_name, space_name|
  click_link 'Account'
  click_link space_name
  page.should have_css('*', text: membership_name)
end