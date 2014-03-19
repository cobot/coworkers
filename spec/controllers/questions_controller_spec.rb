require 'spec_helper'

describe QuestionsController, 'create' do
  before(:each) do
    Space.stub_chain(:by_cobot_id, :first!) {double(:space, id: 'space-1')}
  end

  it "denies access if user is not a space admin" do
    log_in double(:user, admin_of?: false)

    post :create, space_id: 'space-1'

    response.code.should == '403'
  end
end


describe QuestionsController, 'destroy' do
  before(:each) do
    Space.stub_chain(:by_cobot_id, :first!) { double(:space, id: 'space-1') }
  end

  it "denies access if user is not a space admin" do
    log_in double(:user, admin_of?: false)

    delete :destroy, space_id: 'space-1', id: '1'

    response.code.should == '403'
  end
end
