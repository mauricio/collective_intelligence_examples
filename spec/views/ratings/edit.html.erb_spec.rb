require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ratings/edit.html.erb" do
  include RatingsHelper
  
  before(:each) do
    assigns[:rating] = @rating = stub_model(Rating,
      :new_record? => false,
      :score => "9.99",
      :recommended_type => "value for recommended_type"
    )
  end

  it "should render edit form" do
    render "/ratings/edit.html.erb"
    
    response.should have_tag("form[action=#{rating_path(@rating)}][method=post]") do
      with_tag('input#rating_score[name=?]', "rating[score]")
      with_tag('input#rating_recommended_type[name=?]', "rating[recommended_type]")
    end
  end
end


