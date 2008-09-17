require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ratings/show.html.erb" do
  include RatingsHelper
  
  before(:each) do
    assigns[:rating] = @rating = stub_model(Rating,
      :score => "9.99",
      :recommended_type => "value for recommended_type"
    )
  end

  it "should render attributes in <p>" do
    render "/ratings/show.html.erb"
    response.should have_text(/9\.99/)
    response.should have_text(/value\ for\ recommended_type/)
  end
end

