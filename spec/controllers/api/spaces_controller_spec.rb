require 'spec_helper'

describe Api::SpacesController, 'show' do
  before(:each) do
    @user = double(:user,
         id: 'user-1',
         email: 'member1@cobot.me'
       )
    User.stub(find: @user)

    @membership = double(:membership, class: Membership,
         id: 'member-1',
         to_param: 'member-1',
         name: 'member 1',
         user_id: 'user-1',
         website: 'http://member1.test/',
         bio: nil,
         profession: 'Web',
         industry: 'Web',
         skills: 'all',
         picture: 'http://example.com/pic.jpg',
         messenger_type: 'Twitter',
         messenger_account: 'cobot_me',
         user: @user
    )
    @space = double(:space, class: Space,
      name: 'space 1',
      id: 'space-1',
      to_param: 'space-1').as_null_object
    @space.stub_chain(:memberships, :includes) { [@membership] }
    Space.stub_chain(:by_cobot_id, :first!) { @space }

    answer = double(:answer, question: 'achievements', text: 'ran 5k', membership_id: 'member-1')
    @membership.stub(answers: [answer])
  end

  it "returns the space and member parameters as json" do
    get :show, id: 'space-1'

    expect(response.code).to eql('200')
    expect(response.body).to eql({
      id: "space-1", name: "space 1", url: "http://test.host/spaces/space-1",
      memberships: [
        {id: "member-1", name: "member 1", url:"http://test.host/spaces/space-1/memberships/member-1",
          image_url: "http://example.com/pic.jpg", website:"http://member1.test/", bio: nil, profession:"Web",
          industry: "Web", skills:"all", messenger: {'Twitter' => 'cobot_me'},
          questions: [{'achievements' => 'ran 5k'}]}]}.to_json)
  end

  it "returns the spaces parameters in jsonp" do
    get :show, id: 'space-1', callback: 'myFunction'

    expect(response.body).to include('myFunction(')
  end

  it 'renders no messenger if user has none' do
    @membership.stub(messenger_type: '')

    get :show, id: 'space-1'

    expect(JSON.parse(response.body)['memberships'][0]['messenger']).to be_nil
  end

  it 'returns 403 if the space is not viewable' do
    @space.stub(:viewable_by?).with(nil) {false}

    get :show, id: 'space-1', format: :json

    expect(response.status).to eql(403)
  end

  it 'returns 200 if the space is not viewable but the secret matches' do
    @space.stub(:viewable_by?).with(nil) {false}
    @space.stub(:secret) {'123'}

    get :show, id: 'space-1', secret: '123', format: :json

    expect(response.status).to eql(200)
  end
end
