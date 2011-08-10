require 'spec_helper'

describe Api::SpacesController, 'show' do
  before(:each) do
    @space = stub(:space, class: Space,
      name: 'space 1',
      _id: 'space-1',
      to_param: 'space-1',
      memberships: [
        stub(:membership, class: Membership,
         _id: 'member-1',
         to_param: 'member-1',
         name: 'member 1',
         user: stub(:user, 
           email: 'member1@cobot.me',
           login: 'member1',
           website: 'http://member1.test/',
           bio: nil,
           profession: 'Web',
           industry: 'Web',
           skills: 'all'
         )
      )
    ]).as_null_object
    db = stub_db load!: @space
  end
  
  it "returns the spaces parameters in json" do
    get :show, id: 'space-1'
    
    response.code.should == '200'
    response.body.should == '{"id":"space-1","name":"space 1","url":"http://test.host/spaces/space-1","memberships":[{"id":"member-1","name":"member 1","url":"http://test.host/spaces/space-1/memberships/member-1","image_url":"http://gravatar.com/avatar/70a42d54533c6ffc4c30654c998f29c1?d=mm&size=50","login":"member1","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"}]}'
  end
  
  it "returns the spaces parameters in jsonp" do
    get :show, id: 'space-1', callback: 'myFunction'
    
    response.code.should == '200'
    response.body.should == 'myFunction({"id":"space-1","name":"space 1","url":"http://test.host/spaces/space-1","memberships":[{"id":"member-1","name":"member 1","url":"http://test.host/spaces/space-1/memberships/member-1","image_url":"http://gravatar.com/avatar/70a42d54533c6ffc4c30654c998f29c1?d=mm&size=50","login":"member1","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"}]});'
  end

  it 'returns 403 if the space is not viewable' do
    @space.stub(:viewable_by?).with(nil) {false}

    get :show, id: 'space-1', format: :json

    response.status.should == 403
  end

  it 'returns 200 if the space is not viewable but the secret matches' do
    @space.stub(:viewable_by?).with(nil) {false}
    @space.stub(:secret) {'123'}
    
    get :show, id: 'space-1', secret: '123', format: :json

    response.status.should == 200
  end
end