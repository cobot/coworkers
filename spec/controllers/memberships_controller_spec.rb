require 'spec_helper'

describe MembershipsController, 'create', type: :controller do
  let(:space) { double(:space, id: 'space-1', subdomain: 'co-up', to_params: 'space-1') }
  let(:membership) { double(:membership, save: false, id: 1).as_null_object }

  before(:each) do
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) { space }
    allow(controller).to receive(:redirect_to)
  end

  it 'allows admins to update any member' do
    allow(controller).to receive(:render)
    log_in double(:user, admin_of?: true)
    allow(space).to receive_message_chain(:memberships, :find) { membership }

    put :update, space_id: 'space-1', id: '1', membership: {}

    expect(response.status).to eq(200)
  end

  it 'allows members to update themselves' do
    allow(controller).to receive(:render)
    log_in double(:user, admin_of?: false, member_of?: true, membership_for: membership)
    allow(space).to receive_message_chain(:memberships, :find) { membership }

    put :update, space_id: 'space-1', id: '1', membership: {}

    expect(response.status).to eq(200)
  end

  it 'does not allow members to update others' do
    other_membership = double(:other_membership, id: 2).as_null_object
    log_in double(:user, admin_of?: false, member_of?: true, membership_for: other_membership)
    allow(space).to receive_message_chain(:memberships, :find) { membership }

    put :update, space_id: 'space-1', id: '1', membership: {}

    expect(response.status).to eq(403)
  end
end
