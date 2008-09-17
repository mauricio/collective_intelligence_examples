require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/new.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movie] = stub_model(Movie,
      :new_record? => true,
      :title => "value for title"
    )
  end

  it "should render new form" do
    render "/movies/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", movies_path) do
      with_tag("input#movie_title[name=?]", "movie[title]")
    end
  end
end


