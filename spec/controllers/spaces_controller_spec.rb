require 'spec_helper'

describe SpacesController, 'show', type: :controller do
  it 'renders show' do
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) {double(:space, viewable_by?: true).as_null_object}

    get :show, id: '1'

    expect(response).to render_template('show')
  end

  it 'redirects to the login if not allowed to view the space' do
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) {double(:space, viewable_by?: false)}

    get :show, id: '1'

    expect(response).to redirect_to(new_session_path)
  end

  it 'redirects to edit profile if the profile has not been completed' do
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) {double(:space, viewable_by?: true, to_param: 'co-up').as_null_object}
    log_in double(:user, membership_for: double(:membership, to_param: 'mem-1', profile_completed?: false), admin_of?: false)

    get :show, id: '1'

    expect(response).to redirect_to(edit_space_membership_path('co-up', 'mem-1'))
  end

  it 'does not redirect to profile if admin' do
    space = double(:space, viewable_by?: true).as_null_object
    user = double(:user, profile_completed?: false)
    allow(user).to receive(:admin_of?).with(space) {true}
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) { space }
    log_in user

    get :show, id: '1'

    expect(response).to render_template('show')
  end

  it 'renders 403 if logged in and not allowed to view the space' do
    user = double(:user).as_null_object
    space = double(:space).as_null_object
    log_in user
    allow(space).to receive(:viewable_by?).with(user) {false}
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) { space }

    get :show, id: '1'

    expect(response.status).to eq(403)
  end
end

describe SpacesController, 'update' do
  before(:each) do
    @space = double(:space, to_param: 'space-1').as_null_object
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) { @space }
    @user = double(:user)
    log_in @user
  end

  it 'updates the space' do
    expect(@space).to receive(:members_only=).with('1')

    put :update, id: 'space-1', space: {members_only: '1'}
  end

  it 'it saves the space' do
    expect(@space).to receive(:save!)

    put :update, id: 'space-1', space: {}
  end

  it 'redirects to the space' do
    put :update, id: 'space-1', space: {}

    expect(response).to redirect_to(space_path(@space))
  end

  it 'does nothing if the user isn\'t allowed do update the space' do
    allow(@space).to receive(:updatable_by?).with(@user) {false}

    expect(@space).not_to receive(:save!)

    put :update, id: 'space-1', space: {}
  end
end
