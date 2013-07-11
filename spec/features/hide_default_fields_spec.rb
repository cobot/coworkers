require 'spec_helper'

feature 'hide default fields' do
  background do
    auth_mock({id: 'user-joe', memberships: [{space_subdomain: "co-up",
      space_link: "https://www.cobot.me/api/spaces/co-up",
      link: "https://co-up.cobot.me/api/memberships/mem-1" }]})
    stub_cobot_membership 'co.up', 'joe', 'mem-1'
    stub_space 'co-up', 'co.up'
  end

  scenario 'does not show the fields' do
    sign_in
    space = Space.last
    space.update_attribute :hide_default_fields, true

    visit edit_space_membership_path(space, Membership.last)

    expect(page).to have_no_content('Profession')
  end
end
