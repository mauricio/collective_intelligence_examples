require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ratings/index.html.erb" do
  include RatingsHelper
  
  before(:each) do
    assigns[:ratings] = [
      stub_model(Rating,
        :score => "9.99",
        :recommended_type => "value for recommended_type"
      ),
      stub_model(Rating,
        :score => "9.99",
        :recommended_type => "value for recommended_type"
      )
    ]
  end

  it "should render list of ratings" do
    render "/ratings/index.html.erb"
    response.should have_tag("tr>td", "9.99", 2)
    response.should have_tag("tr>td", "value for recommended_type", 2)
  end
end

