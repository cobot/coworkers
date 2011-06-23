require 'spec_helper'

describe MembershipsImportsController, 'create' do
  context "logged in admin" do
    before(:each) do
      current_user = stub('current_user', admin_of?: true)
      controller.stub(current_user: current_user)
      space = stub(:space, subdomain: 'my_space')
      stub_db.stub(:load).with('space_id').and_return(space)
    end

    it "should get memberships information from the cobot api" do
      space = stub(:space, subdomain: 'my_space')
      stub_db.stub(:load).with('space_id').and_return(space)
      token = stub('access_token')
      session[:access_token] = token
      token.should_receive(:get).with("https://my_space.cobot.me/api/memberships")
      post :create, :space_id => 'space_id'
    end

    it "should import the memberships" do
      token = stub('access_token')
      session[:access_token] = token
      MembershipsImporter.should_receive(:import).with("membership")
      token.stub(:get).and_return(["membership"])
      post :create, :space_id => 'space_id'
    end
    
  end
  
end
