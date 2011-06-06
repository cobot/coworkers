require 'spec_helper'

describe User, '#admin_of?' do
  it "returns true if the space id is in the admin_of array" do
    User.new(admin_of: ['space-1']).should be_admin_of(stub(:space, id: 'space-1'))
  end
  
  it "returns false if the space id is not in the admin_of array" do
    User.new(admin_of: ['space-1']).should_not be_admin_of(stub(:space, id: 'space-2'))
  end
end
