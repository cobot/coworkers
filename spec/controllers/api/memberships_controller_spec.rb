require 'spec_helper'

describe Api::MembershipsController, 'show' do
  before(:each) do
    db = stub_db
    db.stub(:load).with('space-1') {
      stub(:space, class: Space, name: 'space 1', _id: 'space-1', to_param: 'space-1')
    }
    
    @membership = stub(:membership, class: Membership, _id: 'member-1', to_param: 'member-1', name: 'member 1',
      user: stub(:user, email: 'member1@cobot.me', login: 'member1', website: 'http://member1.test/', bio: nil,
        profession: 'Web', industry: 'Web', skills: 'all', picture: 'http://example.com/pic.jpg'))
    db.stub(:load).with('member-1') {@membership}
  end
  
  it "returns the membership parameters in json" do
    get :show, space_id: 'space-1', id: 'member-1'
    
    response.code.should == '200'
    response.body.should == '{"id":"member-1","name":"member 1","image_url":"http://example.com/pic.jpg","login":"member1","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"}'
  end
  
  it "returns the membership parameters in jsonp" do
    get :show, space_id: 'space-1', id: 'member-1', callback: 'myFunction'
    
    response.code.should == '200'
    response.body.should == 'myFunction({"id":"member-1","name":"member 1","image_url":"http://example.com/pic.jpg","login":"member1","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"});'
  end
  
end