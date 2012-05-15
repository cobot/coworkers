require 'spec_helper'

describe Api::SpacesController, 'show' do
  before(:each) do
    @space = stub(:space, class: Space,
      name: 'space 1',
      _id: 'space-1',
      to_param: 'space-1',
      memberships: [
        stub(:membership, class: Membership,
         id: 'member-1',
         to_param: 'member-1',
         name: 'member 1',
         user_id: 'user-1'
      )
    ]).as_null_object
    db = stub_db load!: @space

    @user = stub(:user,
         id: 'user-1',
         email: 'member1@cobot.me',
         website: 'http://member1.test/',
         bio: nil,
         profession: 'Web',
         industry: 'Web',
         skills: 'all',
         picture: 'http://example.com/pic.jpg',
         messenger_type: 'Twitter',
         messenger_account: 'cobot_me'
       )
    db.stub_view(User, :by_id).with(keys: ['user-1']) {[@user]}

    answer = stub(:answer, question: 'achievements', text: 'ran 5k', membership_id: 'member-1')
    db.stub_view(Answer, :by_membership_id).with(keys: ['member-1']) {[answer]}
  end

  it "returns the space and member parameters as json" do
    get :show, id: 'space-1'

    response.code.should == '200'
    response.body.should == {
      id: "space-1", name: "space 1", url: "http://test.host/spaces/space-1",
      memberships: [
        {id: "member-1", name: "member 1", url:"http://test.host/spaces/space-1/memberships/member-1",
          image_url: "http://example.com/pic.jpg", website:"http://member1.test/", bio: nil, profession:"Web",
          industry: "Web", skills:"all", messenger: {'Twitter' => 'cobot_me'},
          questions: [{'achievements' => 'ran 5k'}]}]}.to_json
  end

  it "returns the spaces parameters in jsonp" do
    get :show, id: 'space-1', callback: 'myFunction'

    response.body.should include('myFunction(')
  end

  it 'renders no messenger if user has none' do
    @user.stub(messenger_type: '')

    get :show, id: 'space-1'

    JSON.parse(response.body)['memberships'][0]['messenger'].should be_nil
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
