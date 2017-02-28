require 'spec_helper'

describe 'space api' do
  it 'returns the members' do
    space = Space.create! cobot_id: 'space-co-up'
    user = User.create!
    Membership.create! space_id: space.id, user_id: user.id, name: 'joe doe', public: true

    visit api_space_path(space)

    expect(page.source).to include('joe doe')
  end
end
