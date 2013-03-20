require 'spec_helper'

describe SpacesController, 'show' do
  it 'renders show' do
    Space.stub_chain(:by_cobot_id, :first!) {stub(:space, viewable_by?: true).as_null_object}

    get :show, id: '1'

    response.should render_template('show')
  end

  it 'redirects to the login if not allowed to view the space' do
    Space.stub_chain(:by_cobot_id, :first!) {stub(:space, viewable_by?: false)}

    get :show, id: '1'

    response.should redirect_to(new_session_path)
  end

  it 'redirects to edit profile if the profile has not been completed' do
    Space.stub_chain(:by_cobot_id, :first!) {stub(:space, viewable_by?: true, to_param: 'co-up').as_null_object}
    log_in stub(:user, membership_for: stub(:membership, to_param: 'mem-1', profile_completed?: false), admin_of?: false)

    get :show, id: '1'

    response.should redirect_to(edit_space_membership_path('co-up', 'mem-1'))
  end

  it 'does not redirect to profile if admin' do
    space = stub(:space, viewable_by?: true).as_null_object
    user = stub(:user, profile_completed?: false)
    user.stub(:admin_of?).with(space) {true}
    Space.stub_chain(:by_cobot_id, :first!) { space }
    log_in user

    get :show, id: '1'

    response.should render_template('show')
  end

  it 'renders 403 if logged in and not allowed to view the space' do
    user = stub(:user).as_null_object
    space = stub(:space).as_null_object
    log_in user
    space.stub(:viewable_by?).with(user) {false}
    Space.stub_chain(:by_cobot_id, :first!) { space }

    get :show, id: '1'

    response.status.should == 403
  end
end

describe SpacesController, 'update' do
  before(:each) do
    @space = stub(:space, to_param: 'space-1').as_null_object
    Space.stub_chain(:by_cobot_id, :first!) { @space }
    @user = stub(:user)
    log_in @user
  end

  it 'updates the space' do
    @space.should_receive(:members_only=).with('1')

    put :update, id: 'space-1', space: {members_only: '1'}
  end

  it 'it saves the space' do
    @space.should_receive(:save!)

    put :update, id: 'space-1', space: {}
  end

  it 'redirects to the space' do
    put :update, id: 'space-1', space: {}

    response.should redirect_to(space_path(@space))
  end

  it 'does nothing if the user isn\'t allowed do update the space' do
    @space.stub(:updatable_by?).with(@user) {false}

    @space.should_not_receive(:save!)

    put :update, id: 'space-1', space: {}
  end
end
