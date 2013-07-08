require 'spec_helper'

describe MembershipImportsController, 'create' do
  before(:each) do
    Space.stub_chain(:by_cobot_id, :first!) {
      stub(:space, id: 'space-1', cobot_url: 'co-up')
    }
    @access_token = stub(:access_token).as_null_object
    OAuth2::AccessToken.stub(new: @access_token)
  end

  it "denies access if user is not a space admin" do
    log_in stub(:user, admin_of?: false)

    post :create, space_id: 'space-1'

    expect(response.code).to eql('403')
  end

  it 'assigns the memberships that have not been imported already' do
    log_in stub(:user, admin_of?: true).as_null_object
    Membership.stub(:where) { [stub(:membership, cobot_id: '123')] }

    @access_token.stub(:get).with('co-up/api/memberships') {
      stub(:result, parsed: [
        {'id' => '123'}, {'id' => '456', 'address' => {'name' => 'joe'}}
      ])
    }

    get :new

    expect(assigns(:memberships).map(&:cobot_id)).to eql(['456'])
  end
end
