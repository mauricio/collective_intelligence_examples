require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/index.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movies] = [
      stub_model(Movie,
        :title => "value for title"
      ),
      stub_model(Movie,
        :title => "value for title"
      )
    ]
  end

  it "should render list of movies" do
    render "/movies/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
  end
end

