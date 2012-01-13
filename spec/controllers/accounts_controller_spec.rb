require 'spec_helper'

describe AccountsController, 'update' do
  it "protects the email and admin_of attributes" do
    stub_db.as_null_object
    user = stub(:user)
    log_in user

    user.should_receive(:attributes=).with('industry' => 'IT')

    post :update, id: '1', user: {email: 'evil', admin_of: 'hacker', industry: 'IT'}
  end
end

describe AccountsController, 'show' do
  before(:each) do
    log_in stub(:user, admin_of: []).as_null_object
    @db = stub_db view: []
  end

  it 'redirects to the space if there is only one' do
    @db.stub_view(Space, :by_id) {[stub(:space, to_param: 'co-up')]}

    get :show

    response.should redirect_to(space_path('co-up'))
  end

  it 'does not redirect if there is more than one space' do
    @db.stub_view(Space, :by_id) {[stub(:space1), stub(:space2)]}

    get :show

    response.should render_template('show')
  end
end
