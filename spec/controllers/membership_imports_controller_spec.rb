require 'spec_helper'

describe MembershipImportsController, 'create', type: :controller do
  before(:each) do
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) {
      double(:space, id: 'space-1', subdomain: 'co-up').as_null_object
    }
    @client = double(:api_client).as_null_object
    allow(CobotClient::ApiClient).to receive_messages(new: @client)
  end

  it 'denies access if user is not a space admin' do
    log_in double(:user, admin_of?: false)

    post :create, space_id: 'space-1'

    expect(response.code).to eql('403')
  end

  it 'assigns the memberships that have not been imported already' do
    log_in double(:user, admin_of?: true).as_null_object
    allow(Membership).to receive(:where) { [double(:membership, cobot_id: '123')] }

    allow(@client).to receive(:get).with('co-up', '/memberships', attributes: 'name,id') {
      [
        {id: '123'}, {id: '456', name: 'joe'}
      ]
    }

    get :new, space_id: 'space-1'

    expect(assigns(:memberships).map(&:cobot_id)).to eql(['456'])
  end
end
