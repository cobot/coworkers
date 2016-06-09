require 'spec_helper'

describe User, '#admin_of?' do
  it "returns true if the space id is in the admin_of array" do
    expect(User.new(admin_of: {'space-1' => 'alex'})).to be_admin_of(double(:space, cobot_id: 'space-1'))
  end

  it "returns false if the space id is not in the admin_of array" do
    expect(User.new(admin_of: {'space-1' => 'alex'})).not_to be_admin_of(double(:space, cobot_id: 'space-2'))
  end
end

describe User, '#admin_for' do
  it 'returns the admin for the space' do
    expect(User.new(admin_of: {'space-1' => 'joe'}).admin_for(double(:space, cobot_id: 'space-1')).name).to eq('joe')
  end

  it 'returns nil if the user is not the admin of the given space' do
    expect(User.new(admin_of: {'space-2' => 'alex'}).admin_for(double(:space, cobot_id: 'space-1'))).to be_nil
  end
end
