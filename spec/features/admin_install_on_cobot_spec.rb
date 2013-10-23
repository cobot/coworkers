require 'spec_helper'

describe 'installing coworkers on cobot' do
  it 'sets up navigation links and redirects to cobot' do
    WebMock.stub_request(:get, 'https://co-up.cobot.me/api/navigation_links').to_return(headers: default_headers, body: [].to_json)
    WebMock.stub_request(:post, 'https://co-up.cobot.me/api/navigation_links').to_return(headers: default_headers, body:
      ->(request) {
        Hash[URI.decode_www_form(request.body)].merge(user_url: 'https://co-up.cobot.me/navigation_links/link-1').to_json
      })

    stub_cobot_admin 'co.up', 'joe'
    sign_in
    space = space_by_name('co.up')
    visit account_path
    click_link 'Install on Cobot'
    space = last_space

    should_have_installed_link('co-up',
      section: 'admin/manage', label: 'Coworker Profiles', iframe_url: "http://www.example.com/spaces/co-up/memberships")
    should_have_installed_link('co-up',
      section: 'admin/setup', label: 'Coworker Profiles', iframe_url: "http://www.example.com/spaces/co-up/questions")
    should_have_installed_link('co-up',
      section: 'members', label: 'Coworkers', iframe_url: "http://www.example.com/spaces/co-up/memberships")

    expect(current_url).to eql('https://co-up.cobot.me/navigation_links/link-1')

    space.memberships.create! name: 'joe doe'
    visit 'http://www.example.com/spaces/co-up/memberships'
    expect(page).to have_content('joe doe')
  end

  def should_have_installed_link(subdomain, attributes)
    WebMock.should have_requested(:post, "https://#{subdomain}.cobot.me/api/navigation_links").with(
      body: attributes)
  end

  def default_headers
    {'Content-Type' => 'application/json'}
  end
end
