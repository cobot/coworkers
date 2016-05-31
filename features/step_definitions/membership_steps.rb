Given(/^"([^"]*)" has a member "([^"]*)"(?: with email "([^"]*)")?$/) do |space_name, member_name, member_email|
  user = User.create!(email: member_email || 'joe@doe.com')
  space_by_name(space_name).memberships.create!(name: member_name, user_id: user.id, cobot_id: member_name.gsub(/\W+/, '-'))
end

Given(/^"([^"]*)" has a member "([^"]*)" with email "([^"]*)" and profession "([^"]*)"$/) do |space_name, member_name, member_email, profession|
  user = User.create!(email: member_email || 'joe@doe.com')
  space_by_name(space_name).memberships.create!(profession: profession,
    name: member_name, user_id: user.id, cobot_id: member_name.gsub(/\W+/, '-'))
end


Given(/^"([^"]*)" has a member "([^"]*)" with cobot id "([^"]*)"$/) do |space_name, member_name, cobot_id|
  user = User.create!(email: 'joe@doe.com', cobot_id: cobot_id)
  space_by_name(space_name).memberships.create!(name: member_name, user_id: user.id, cobot_id: member_name.gsub(/\W+/, '-'))
end

Then(/^"([^"]+)" should be listed as a member of the space "([^"]+)"(?: once)?$/) do |membership_name, space_name|
  visit space_memberships_path(space_by_name(space_name))
  expect(page.all('.test-member', text: membership_name).size).to eq(1)
end

Then(/^"([^"]+)" should not be listed as a member of the space "([^"]+)"(?: once)?$/) do |membership_name, space_name|
  visit space_memberships_path(space_by_name(space_name))

  expect(page.all('.test-member', text: membership_name).size).to eq(1)
end

Then(/^I should see "([^"]*)" and "([^"]*)" as members of "([^"]*)"$/) do |name_1, name_2, space_name|
  visit space_memberships_path(space_by_name(space_name))

  page.should have_css('*', text: name_1)
  page.should have_css('*', text: name_2)
end

When(/^I visit the profile page of "([^"]*)"$/) do |email|
  user = User.where(email: email).first!
  membership = user.memberships.first!
  space = membership.space
  visit space_membership_url(space, membership)
end
