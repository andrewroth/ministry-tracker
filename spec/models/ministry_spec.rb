require File.dirname(__FILE__) + '/../spec_helper'

describe Ministry do
  fixtures Ministry.table_name, MinistryCampus.table_name, Campus.table_name
  before(:each) do
    @ministry = Ministry.find(1)
  end

  it "should return a list of campuses in sub-ministries" do
    @ministry.subministry_campuses.should have(2).record
  end
  
  it "should return a list of campuses on this ministry" do
    @ministry.campuses.should have(2).records
  end
  
  it "should return a combined list of campuses including child campuses" do
    @ministry.unique_campuses.should have(3).records
  end
  
  it "should provide a list of ids corresponding to campuses on this ministry" do
    @ministry.campus_ids.should have(3).records
  end
  
  it "should return a list of all it's descendants" do
    @ministry.descendants.should == [Ministry.find(2), Ministry.find(3)]
  end
  
  it "should return it's root level element" do
    @ministry.root.should eql(@ministry)
    Ministry.find(2).root.should eql(@ministry)
  end

  it "should tell you if it's the root element" do
    @ministry.should be_root
  end
  
  it "should return itself with all children" do
    @ministry.all_ministries.should have(3).records
    @ministry.all_ministries.should == [Ministry.find(2), Ministry.find(3), @ministry]
  end
  
  it "can't be deleted if it's a root element" do
    @ministry.should_not be_deleteable
  end
  
  it "should be considered equal to another ministry with the same name" do
    @ministry == Ministry.new(:name => @ministry.name)
  end
  
end
