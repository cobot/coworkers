require 'spec_helper'

describe SpacesController, 'show' do
  before(:each) do
    @db = stub_db
  end

  it 'renders show' do
    @db.stub(:load!) {stub(:space, viewable_by?: true)}

    get :show, id: '1'

    response.should render_template('show')
  end

  it 'redirects to the login if not allowed to view the space' do
    @db.stub(:load!) {stub(:space, viewable_by?: false)}

    get :show, id: '1'

    response.should redirect_to(authenticate_path)
  end

  it 'renders 403 if logged in and not allowed to view the space' do
    user = stub(:user)
    space = stub(:space)
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