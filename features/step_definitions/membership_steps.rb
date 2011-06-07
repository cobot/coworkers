Given /^"([^"]*)" has a member "([^"]*)" with email "([^"]*)"$/ do |space_name, member_name, member_email|
  user = User.new(login: member_name, email: member_email)
  DB.save! user
  DB.save! Membership.new(space_id: space_by_name(space_name).id,
    name: member_name, id: member_name.gsub(/\W+/, '_'), user_id: user.id)
end

Then /^"([^"]+)" should be listed as a member of the space "([^"]+)"(?: once)?$/ do |membership_name, space_name|
  click_link 'Account'
  click_link space_name
  page.all('.membership', text: membership_name).should have(1).item
end

Then /^I should see "([^"]*)" and "([^"]*)" as members of "([^"]*)"$/ do |name_1, name_2, space_name|
  click_link 'Account'
  click_link space_name
  page.should have_css('*', text: name_1)
  page.should have_css('*', text: name_2)
end