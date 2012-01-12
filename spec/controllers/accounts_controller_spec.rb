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
