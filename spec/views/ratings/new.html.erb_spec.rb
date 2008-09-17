require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ratings/new.html.erb" do
  include RatingsHelper
  
  before(:each) do
    assigns[:rating] = stub_model(Rating,
      :new_record? => true,
      :score => "9.99",
      :recommended_type => "value for recommended_type"
    )
  end

  it "should render new form" do
    render "/ratings/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", ratings_path) do
      with_tag("input#rating_score[name=?]", "rating[score]")
      with_tag("input#rating_recommended_type[name=?]", "rating[recommended_type]")
    end
  end
end


