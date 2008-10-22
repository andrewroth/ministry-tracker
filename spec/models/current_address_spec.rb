require File.dirname(__FILE__) + '/../spec_helper'

describe CurrentAddress do
  before(:each) do
    @current_address = CurrentAddress.new
  end

  it "should have an address type of 'current' when created" do
    @current_address.save!
    @current_address.address_type.should == "current"
  end
end
