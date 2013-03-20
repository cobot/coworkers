require 'spec_helper'

describe 'space api' do
  before(:each) do
    DatabaseCleaner.clean_with :truncation
  end

  it 'returns the members' do
    space = Space.create! subdomain: 'co-up'
    user = User.create!
    membership = Membership.create! space_id: space.id, user_id: user.id, name: 'joe doe'

    visit api_space_path(space)

    expect(page.source).to include('joe doe')
  end
end
