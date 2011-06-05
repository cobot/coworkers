Given /^"([^"]*)" has a member "([^"]*)"$/ do |space_name, member_name|
  DB.save! Membership.new(space_id: space_by_name(space_name).id, name: member_name)
end

Then /^"([^"]+)" should be listed as a member of the space "([^"]+)"$/ do |membership_name, space_name|
  click_link 'Account'
  click_link space_name
  page.should have_css('*', text: membership_name)
end

Then /^I should see "([^"]*)" and "([^"]*)" as members of "([^"]*)"$/ do |name_1, name_2, space_name|
  click_link 'Account'
  click_link space_name
  page.should have_css('*', text: name_1)
  page.should have_css('*', text: name_2)
end