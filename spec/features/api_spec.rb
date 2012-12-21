require 'spec_helper'

describe 'space api' do
  before(:each) do
    @db = CouchPotato.database
  end

  it 'returns the members' do
    space = Space.new
    @db.save! space
    user = User.new
    @db.save! user
    membership = Membership.new space_id: space.id, user_id: user.id, name: 'joe doe'
    @db.save! membership

    visit api_space_path(space)

    expect(page.source).to include('joe doe')
  end
end
