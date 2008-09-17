require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MoviesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "movies", :action => "index").should == "/movies"
    end
  
    it "should map #new" do
      route_for(:controller => "movies", :action => "new").should == "/movies/new"
    end
  
    it "should map #show" do
      route_for(:controller => "movies", :action => "show", :id => 1).should == "/movies/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "movies", :action => "edit", :id => 1).should == "/movies/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "movies", :action => "update", :id => 1).should == "/movies/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "movies", :action => "destroy", :id => 1).should == "/movies/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/movies").should == {:controller => "movies", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/movies/new").should == {:controller => "movies", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/movies").should == {:controller => "movies", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/movies/1").should == {:controller => "movies", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/movies/1/edit").should == {:controller => "movies", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/movies/1").should == {:controller => "movies", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/movies/1").should == {:controller => "movies", :action => "destroy", :id => "1"}
    end
  end
end
