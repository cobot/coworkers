require 'spec_helper'

describe Api::SpacesController, 'show', type: :controller do
  before(:each) do
    @user = double(:user, id: 'user-1', email: 'member1@cobot.me')
    allow(User).to receive_messages(find: @user)

    @space = double(:space, class: Space,
      name: 'space 1',
      id: 'space-1',
      subdomain: 'space-1',
      secret: 's3cr3t',
      to_param: 'space-1').as_null_object
    @membership = double(:membership, class: Membership,
         id: 'member-1',
         cobot_id: 'mem-1',
         to_param: 'member-1',
         name: 'member 1',
         user_id: 'user-1',
         website: 'http://member1.test/',
         bio: nil,
         profession: 'Web',
         industry: 'Web',
         skills: 'all',
         messenger_type: 'Twitter',
         messenger_account: 'cobot_me',
         space: @space,
         user: @user).as_null_object

    allow(@space).to receive_message_chain(:memberships, :active, :published, :includes) { [@membership] }
    allow(Space).to receive_message_chain(:by_cobot_id, :first!) { @space }

    answer = double(:answer, question: 'achievements', text: 'ran 5k', membership_id: 'member-1')
    allow(@membership).to receive_messages(answers: [answer])
  end

  it 'returns the space and member parameters as json' do
    get :show, id: 'space-1', secret: 's3cr3t'

    expect(response.code).to eql('200')
    expect(response.body).to eql({
      id: 'space-1', name: 'space 1', url: 'http://test.host/spaces/space-1/memberships',
      memberships: [
        {id: 'member-1', name: 'member 1',
          url: 'http://test.host/spaces/space-1/memberships/member-1',
          image_url: 'https://space-1.cobot.me/api/memberships/mem-1/picture?picture_size=small',
          website: 'http://member1.test/', bio: nil, profession: 'Web',
          industry: 'Web', skills: 'all', messenger: {'Twitter' => 'cobot_me'},
          questions: [{'achievements' => 'ran 5k'}]}]}.to_json)
  end

  it 'returns the spaces parameters in jsonp' do
    get :show, id: 'space-1', callback: 'myFunction', secret: 's3cr3t'

    expect(response.body).to include('myFunction(')
  end

  it 'renders no messenger if user has none' do
    allow(@membership).to receive_messages(messenger_type: '')

    get :show, id: 'space-1', secret: 's3cr3t'

    expect(JSON.parse(response.body)['memberships'][0]['messenger']).to be_nil
  end

  it 'returns 403 if the secret does not matchg' do
    get :show, id: 'space-1', secret: 'wrong', format: :json

    expect(response.status).to eql(403)
  end
end
