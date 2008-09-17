require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RatingsController do

  def mock_rating(stubs={})
    @mock_rating ||= mock_model(Rating, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all ratings as @ratings" do
      Rating.should_receive(:find).with(:all).and_return([mock_rating])
      get :index
      assigns[:ratings].should == [mock_rating]
    end

    describe "with mime type of xml" do
  
      it "should render all ratings as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Rating.should_receive(:find).with(:all).and_return(ratings = mock("Array of Ratings"))
        ratings.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested rating as @rating" do
      Rating.should_receive(:find).with("37").and_return(mock_rating)
      get :show, :id => "37"
      assigns[:rating].should equal(mock_rating)
    end
    
    describe "with mime type of xml" do

      it "should render the requested rating as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Rating.should_receive(:find).with("37").and_return(mock_rating)
        mock_rating.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new rating as @rating" do
      Rating.should_receive(:new).and_return(mock_rating)
      get :new
      assigns[:rating].should equal(mock_rating)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested rating as @rating" do
      Rating.should_receive(:find).with("37").and_return(mock_rating)
      get :edit, :id => "37"
      assigns[:rating].should equal(mock_rating)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created rating as @rating" do
        Rating.should_receive(:new).with({'these' => 'params'}).and_return(mock_rating(:save => true))
        post :create, :rating => {:these => 'params'}
        assigns(:rating).should equal(mock_rating)
      end

      it "should redirect to the created rating" do
        Rating.stub!(:new).and_return(mock_rating(:save => true))
        post :create, :rating => {}
        response.should redirect_to(rating_url(mock_rating))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved rating as @rating" do
        Rating.stub!(:new).with({'these' => 'params'}).and_return(mock_rating(:save => false))
        post :create, :rating => {:these => 'params'}
        assigns(:rating).should equal(mock_rating)
      end

      it "should re-render the 'new' template" do
        Rating.stub!(:new).and_return(mock_rating(:save => false))
        post :create, :rating => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested rating" do
        Rating.should_receive(:find).with("37").and_return(mock_rating)
        mock_rating.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :rating => {:these => 'params'}
      end

      it "should expose the requested rating as @rating" do
        Rating.stub!(:find).and_return(mock_rating(:update_attributes => true))
        put :update, :id => "1"
        assigns(:rating).should equal(mock_rating)
      end

      it "should redirect to the rating" do
        Rating.stub!(:find).and_return(mock_rating(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(rating_url(mock_rating))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested rating" do
        Rating.should_receive(:find).with("37").and_return(mock_rating)
        mock_rating.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :rating => {:these => 'params'}
      end

      it "should expose the rating as @rating" do
        Rating.stub!(:find).and_return(mock_rating(:update_attributes => false))
        put :update, :id => "1"
        assigns(:rating).should equal(mock_rating)
      end

      it "should re-render the 'edit' template" do
        Rating.stub!(:find).and_return(mock_rating(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested rating" do
      Rating.should_receive(:find).with("37").and_return(mock_rating)
      mock_rating.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the ratings list" do
      Rating.stub!(:find).and_return(mock_rating(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(ratings_url)
    end

  end

end
