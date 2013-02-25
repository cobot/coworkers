
Given /^"([^"]*)" has a member "([^"]*)"(?: with email "([^"]*)")?$/ do |space_name, member_name, member_email|
  DB.save! user
  DB.save! Membership.new(space_id: space_by_name(space_name).id,
    name: member_name, id: member_name.gsub(/\W+/, '-'), user_id: user.id)
end

Given /^"([^"]*)" has a member "([^"]*)" with cobot id "([^"]*)"$/ do |space_name, member_name, cobot_id|
  user = User.new(email: 'joe@doe.com', cobot_id: cobot_id)
  DB.save! user
  DB.save! Membership.new(space_id: space_by_name(space_name).id,
    name: member_name, id: member_name.gsub(/\W+/, '-'), user_id: user.id)
end

Then /^"([^"]+)" should be listed as a member of the space "([^"]+)"(?: once)?$/ do |membership_name, space_name|
  visit space_memberships_path(space_by_name(space_name))
  page.all('.member', text: membership_name).should have(1).item
end

Then /^"([^"]+)" should not be listed as a member of the space "([^"]+)"(?: once)?$/ do |membership_name, space_name|
  visit space_memberships_path(space_by_name(space_name))
  page.all('.member', text: membership_name).should have(1).item
end

Then /^I should see "([^"]*)" and "([^"]*)" as members of "([^"]*)"$/ do |name_1, name_2, space_name|
  visit space_memberships_path(space_by_name(space_name))
  page.should have_css('*', text: name_1)
  page.should have_css('*', text: name_2)
end

When /^I visit the profile page of "([^"]*)"$/ do |email|
  user = DB.first(User.by_email(email))
  membership = DB.first(Membership.by_user_id(user.id))
  space = DB.load membership.space_id
  visit url_for([space, membership])
end
