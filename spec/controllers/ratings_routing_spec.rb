require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RatingsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "ratings", :action => "index").should == "/ratings"
    end
  
    it "should map #new" do
      route_for(:controller => "ratings", :action => "new").should == "/ratings/new"
    end
  
    it "should map #show" do
      route_for(:controller => "ratings", :action => "show", :id => 1).should == "/ratings/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "ratings", :action => "edit", :id => 1).should == "/ratings/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "ratings", :action => "update", :id => 1).should == "/ratings/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "ratings", :action => "destroy", :id => 1).should == "/ratings/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/ratings").should == {:controller => "ratings", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/ratings/new").should == {:controller => "ratings", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/ratings").should == {:controller => "ratings", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/ratings/1").should == {:controller => "ratings", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/ratings/1/edit").should == {:controller => "ratings", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/ratings/1").should == {:controller => "ratings", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/ratings/1").should == {:controller => "ratings", :action => "destroy", :id => "1"}
    end
  end
end
