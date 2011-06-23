require 'spec_helper'

describe Space do
  it "should return the subdomain of a space" do
    space = Space.new :id => 'space-my-space'
    space.subdomain.should == 'my-space'
  end  
end
