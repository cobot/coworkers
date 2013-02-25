require 'spec_helper'

describe SpacesController, 'show' do
  before(:each) do
    @db = stub_db view: []
  end

  it 'renders show' do
    @db.stub(:load!) {stub(:space, viewable_by?: true).as_null_object}

    get :show, id: '1'

    response.should render_template('show')
  end

  it 'redirects to the login if not allowed to view the space' do
    @db.stub(:load!) {stub(:space, viewable_by?: false).as_null_object}

    get :show, id: '1'

    response.should redirect_to('/auth/cobot')
  end

  it 'redirects to edit profile if the profile has not been completed' do
    @db.stub(:load!) {stub(:space, viewable_by?: true, to_param: 'co-up').as_null_object}
    log_in stub(:user, membership_for: stub(:membership, to_param: 'mem-1', profile_completed?: false), admin_of?: false)

    get :show, id: '1'

    response.should redirect_to(edit_space_membership_path('co-up', 'mem-1'))
  end

  it 'does not redirect to profile if admin' do
    space = stub(:space, viewable_by?: true).as_null_object
    user = stub(:user, profile_completed?: false)
    user.stub(:admin_of?).with(space) {true}
    @db.stub(:load!) {space}
    log_in user

    get :show, id: '1'

    response.should render_template('show')
  end

  it 'renders 403 if logged in and not allowed to view the space' do
    user = stub(:user).as_null_object
    space = stub(:space).as_null_object
    log_in user
    space.stub(:viewable_by?).with(user) {false}
    @db.stub(:load!) {space}

    get :show, id: '1'

    response.status.should == 403
  end
end

describe SpacesController, 'update' do
  before(:each) do
    @space = stub(:space, to_param: 'space-1').as_null_object
    @db = stub_db load!: @space, save!: nil
    @user = stub(:user)
    log_in @user
  end

  it 'loads the space' do
    @db.should_receive(:load!).with('space-1') {@space}

    put :update, id: 'space-1', space: {}
  end

  it 'updates the space' do
    @space.should_receive(:members_only=).with('1')

    put :update, id: 'space-1', space: {members_only: '1'}
  end

  it 'it saves the space' do
    @db.should_receive(:save!).with(@space)

    put :update, id: 'space-1', space: {}
  end

  it 'redirects to the space' do
    put :update, id: 'space-1', space: {}

    response.should redirect_to(space_path(@space))
  end

  it 'does nothing if the user isn\'t allowed do update the space' do
    @space.stub(:updatable_by?).with(@user) {false}

    @db.should_not_receive(:save!)

    put :update, id: 'space-1', space: {}
  end
end
