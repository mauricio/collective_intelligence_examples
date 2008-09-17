require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/edit.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "should render edit form" do
    render "/movies/edit.html.erb"
    
    response.should have_tag("form[action=#{movie_path(@movie)}][method=post]") do
      with_tag('input#movie_title[name=?]', "movie[title]")
    end
  end
end


