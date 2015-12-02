require 'spec_helper'

describe Api::MembershipsController, 'show', type: :controller do
  before(:each) do
    space = double(:space, class: Space, name: 'space 1', id: 'space-1', to_param: 'space-1')
    allow(Space).to receive(:find).with('space-1') { space }

    @membership = double(:membership, class: Membership, id: 'member-1', to_param: 'member-1', name: 'member 1',
      website: 'http://member1.test/', bio: nil, profession: 'Web', industry: 'Web', skills: 'all',
      picture: 'http://example.com/pic.jpg', user: double(:user, email: 'member1@cobot.me'))
    allow(space).to receive_message_chain(:memberships, :active, :find) { @membership }
  end

  it "returns the membership parameters in json" do
    get :show, space_id: 'space-1', id: 'member-1'

    expect(response.code).to eql('200')
    expect(response.body).to eql('{"id":"member-1","name":"member 1","image_url":"http://example.com/pic.jpg","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"}')
  end

  it "returns the membership parameters in jsonp" do
    get :show, space_id: 'space-1', id: 'member-1', callback: 'myFunction'

    expect(response.code).to eql('200')
    expect(response.body).to eql('myFunction({"id":"member-1","name":"member 1","image_url":"http://example.com/pic.jpg","website":"http://member1.test/","bio":null,"profession":"Web","industry":"Web","skills":"all"});')
  end

end
