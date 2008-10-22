require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  fixtures Person.table_name, CustomValue.table_name, User.table_name, Address.table_name
  
  before(:each) do
    @person = Person.find(50000)
  end

  it "should translate integer or single letter to full word" do
    @person.human_gender.should == "Male"
    Person.find(50001).human_gender.should == "Male"
  end
  
  it "should tell us if the person is male" do
    @person.male?.should == true
  end
  
  it "should tell us the person's full name" do
    @person.full_name.should == "Josh Starcher"
  end
  
  it "should return a hash of custom values" do
    @person.custom_value_hash.should == {1 => "hello", 2 => "world"}
  end
  
  it "should return a custom value" do
    @person.get_value(1).should == "hello"
  end
  
  it "should set an existing custom value" do
    @person.set_value(1, "goodbye")
    @person.get_value(1).should == "goodbye"
  end
  
  it "should set a new custom value" do
    @person.set_value(3, "friend")
    @person.get_value(3).should == "friend"
  end
  
  it "should find and existing person with the same email address" do
    Person.find_exact(@person, @person.current_address).should == @person
  end
  
  it "should find an existing person with the same username" do
    fred = Person.find(50001)
    address = Address.new(:email => 'fred@uscm.org')
    Person.find_exact(fred, address).should == fred
  end
  
end
