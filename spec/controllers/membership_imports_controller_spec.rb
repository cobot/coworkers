require 'spec_helper'

describe MembershipImportsController, 'create' do
  before(:each) do
    db = stub_db load!: stub(:space, id: 'space-1')
  end

  it "denies access if user is not a space admin" do
    log_in stub(:user, admin_of?: false)

    post :create, space_id: 'space-1'

    response.code.should == '403'
  end
end
