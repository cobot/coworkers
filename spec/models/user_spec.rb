require 'spec_helper'

describe User, '#admin_of?' do
  it "returns true if the space id is in the admin_of array" do
    User.new(admin_of: [{space_id: 'space-1'}]).should be_admin_of(stub(:space, id: 'space-1'))
  end

  it "returns false if the space id is not in the admin_of array" do
    User.new(admin_of: [{space_id: 'space-1'}]).should_not be_admin_of(stub(:space, id: 'space-2'))
  end
end

describe User, '#admin_for' do
  it 'returns the admin for the space' do
    User.new(admin_of: [{space_id: 'space-1', name: 'joe'}]).admin_for(stub(:space, id: 'space-1')).name.should == 'joe'
  end

  it 'returns nil if the user is not the admin of the given space' do
    User.new(admin_of: [{space_id: 'space-2'}]).admin_for(stub(:space, id: 'space-1')).should be_nil
  end
end
