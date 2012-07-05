require 'spec_helper'


describe Space, '#memberships' do
  let(:db) { stub_db(view: []) }
  let(:space) { Space.new(id: 'co-up', database: db) }

  it 'loads the memberships from the database' do
    Membership.should_receive(:by_space_id).with('co-up')

    space.memberships
  end

  it 'sorts the members by last name' do
    db.stub_view(Membership, :by_space_id) {[stub(:member_1, last_name: 'schulz'), stub(:member_2, last_name: 'meyer')]}

    space.memberships.map(&:last_name).should eql(['meyer', 'schulz'])
  end

  it 'can sort members without a last name' do
    db.stub_view(Membership, :by_space_id) {[stub(:member_1, last_name: 'schulz'), stub(:member_2, last_name: nil)]}

    space.memberships.map(&:last_name).should eql([nil, 'schulz'])
  end
end

describe Space, '#updatable_by?' do
  it 'returns true if the user is an admin of the space' do
    space = Space.new(id: 'co-up')
    user = stub(:user)
    user.stub(:admin_of?).with(space) {true}

    space.should be_updatable_by(user)
  end

  it 'returns false if the user is not an admin' do
    space = Space.new(id: 'co-up')
    user = stub(:user)
    user.stub(:admin_of?).with(space) {false}

    space.should_not be_updatable_by(user)
  end
end

describe Space, 'viewable_by?' do
  it 'returns true if the space is not members only' do
    Space.new(members_only: false).should be_viewable_by(stub(:user))
  end

  it 'returns true if the space is members only and the user is an admin' do
    db = stub(:db, first: nil)
    space = Space.new(database: db, id: 'co-up', members_only: true)
    user = stub(:user).as_null_object
    user.stub(:admin_of?).with(space) {true}

    space.should be_viewable_by(user)
  end

  it 'returns false if the space is members only and the user is not a member' do
    db = stub(:db, first: nil)
    user = stub(:user, admin_of?: false).as_null_object
    Space.new(database: db, members_only: true).should_not be_viewable_by(user)
  end

  it 'returns false if the space is members only and there is no user' do
    db = stub(:db, first: nil)
    Space.new(database: db, members_only: true).should_not be_viewable_by(nil)
  end

  it 'returns true if the space is members only and the user is a member' do
    db = stub_db
    db.stub_view(Membership, :by_space_id_and_user_id).with(
      ['space-1', 'user-1']) {[stub(:membership)]}
    user = stub(:user, id: 'user-1')

    Space.new(id: 'space-1', database: db, members_only: true).should be_viewable_by(user)
  end
end

describe Space, 'creation' do
  it 'sets the secret' do
    space = Space.new

    space.run_callbacks :create

    space.secret.should be_present
  end
end
