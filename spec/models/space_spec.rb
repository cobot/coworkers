require 'spec_helper'

describe Space, '#updatable_by?' do
  it 'returns true if the user is an admin of the space' do
    space = Space.new(id: 'co-up')
    user = double(:user)
    allow(user).to receive(:admin_of?).with(space) {true}

    expect(space).to be_updatable_by(user)
  end

  it 'returns false if the user is not an admin' do
    space = Space.new(id: 'co-up')
    user = double(:user)
    allow(user).to receive(:admin_of?).with(space) {false}

    expect(space).not_to be_updatable_by(user)
  end
end

describe Space, 'viewable_by?' do
  before(:each) do
    allow(Membership).to receive_messages(by_space_id_and_user_id: [])
  end

  it 'returns true if the space is not members only' do
    expect(Space.new(members_only: false)).to be_viewable_by(double(:user))
  end

  it 'returns true if the space is members only and the user is an admin' do
    space = Space.new(id: 'co-up', members_only: true)
    user = double(:user).as_null_object
    allow(user).to receive(:admin_of?).with(space) {true}

    expect(space).to be_viewable_by(user)
  end

  it 'returns false if the space is members only and the user is not a member' do
    user = double(:user, admin_of?: false).as_null_object
    expect(Space.new(members_only: true)).to_not be_viewable_by(user)
  end

  it 'returns false if the space is members only and there is no user' do
    expect(Space.new(members_only: true)).to_not be_viewable_by(nil)
  end

  it 'returns true if the space is members only and the user is a member' do
    allow(Membership).to receive(:by_space_id_and_user_id).with(1, 'user-1') { [double(:membership)] }
    user = double(:user, id: 'user-1')

    expect(Space.new(members_only: true) {|s| s.id = 1}).to be_viewable_by(user)
  end
end

describe Space, 'creation' do
  it 'sets the secret' do
    space = Space.new

    space.run_callbacks :create

    expect(space.secret).to be_present
  end

  it 'sets the subdomain' do
    space = Space.new cobot_url: 'https://some-space.cobot.me'

    space.run_callbacks :create

    expect(space.subdomain).to eql('some-space')
  end
end
