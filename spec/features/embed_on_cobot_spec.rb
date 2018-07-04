require 'spec_helper'

describe 'embed on cobot' do
  let(:space) { space_by_name('co.up') }
  
  before(:example) do
    stub_cobot_admin 'co.up', 'joe'
    sign_in
  end

  it 'uses no custom css in the admin secton' do
    visit space_memberships_path(space, cobot_embed: true, cobot_section: 'admin/manage')

    expect(page).to have_css_link('/assets/application')
  end

  it 'uses custom css in the member secton' do
    visit space_memberships_path(space, cobot_embed: true, cobot_section: 'members')

    expect(page).not_to have_css_link('/assets/application')
  end
end
