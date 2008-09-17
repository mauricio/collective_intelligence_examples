require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/show.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :title => "value for title"
    )
  end

  it "should render attributes in <p>" do
    render "/movies/show.html.erb"
    response.should have_text(/value\ for\ title/)
  end
end

