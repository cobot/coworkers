require 'spec_helper'

describe 'embed on cobot' do
  it 'uses no custom css in the admin secton' do
    stub_cobot_admin 'co.up', 'joe'
    space = Space.create! name: 'co.up', cobot_url: 'http://co-up.cobot.me',
      cobot_id: 'space-co-up'
    User.create!

    visit space_memberships_path(space, cobot_embed: true, cobot_section: 'admin/manage')

    expect(page).to have_css_link('/assets/application')
  end

  it 'uses custom css in the member secton' do
    stub_cobot_admin 'co.up', 'joe'
    space = Space.create! name: 'co.up', cobot_url: 'http://co-up.cobot.me',
      cobot_id: 'space-co-up'
    User.create!

    visit space_memberships_path(space, cobot_embed: true, cobot_section: 'members')

    expect(page).not_to have_css_link('/assets/application')
  end
end
