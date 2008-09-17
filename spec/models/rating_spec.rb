require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rating do
  before(:each) do
    @valid_attributes = {
      :user_id => "1",
      :score => "9.99",
      :recommended_id => "1",
      :recommended_type => "value for recommended_type"
    }
  end

  it "should create a new instance given valid attributes" do
    Rating.create!(@valid_attributes)
  end
end
