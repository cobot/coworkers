require 'spec_helper'

describe 'space custo css' do
  it 'returns the css' do
    stub_cobot_space_customization subdomain: 'co-up', general: {text_color: 'redgreen'}
    stub_cobot_admin 'co-up'
    visit new_session_path
    space = Space.first

    visit space_path(space, format: :css)

    expect(page.source).to include('color: redgreen')
  end

  it 'returns 404 if the space has no custom css' do
    stub_request(:get, /customization/).to_return(status: 404)
    stub_cobot_admin 'co-up'
    visit new_session_path
    space = Space.first

    visit space_path(space, format: :css)

    expect(page.status_code).to eql(404)
  end
end
