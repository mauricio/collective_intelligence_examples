require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MoviesController do

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all movies as @movies" do
      Movie.should_receive(:find).with(:all).and_return([mock_movie])
      get :index
      assigns[:movies].should == [mock_movie]
    end

    describe "with mime type of xml" do
  
      it "should render all movies as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Movie.should_receive(:find).with(:all).and_return(movies = mock("Array of Movies"))
        movies.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested movie as @movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      get :show, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end
    
    describe "with mime type of xml" do

      it "should render the requested movie as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new movie as @movie" do
      Movie.should_receive(:new).and_return(mock_movie)
      get :new
      assigns[:movie].should equal(mock_movie)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested movie as @movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      get :edit, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created movie as @movie" do
        Movie.should_receive(:new).with({'these' => 'params'}).and_return(mock_movie(:save => true))
        post :create, :movie => {:these => 'params'}
        assigns(:movie).should equal(mock_movie)
      end

      it "should redirect to the created movie" do
        Movie.stub!(:new).and_return(mock_movie(:save => true))
        post :create, :movie => {}
        response.should redirect_to(movie_url(mock_movie))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved movie as @movie" do
        Movie.stub!(:new).with({'these' => 'params'}).and_return(mock_movie(:save => false))
        post :create, :movie => {:these => 'params'}
        assigns(:movie).should equal(mock_movie)
      end

      it "should re-render the 'new' template" do
        Movie.stub!(:new).and_return(mock_movie(:save => false))
        post :create, :movie => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "should expose the requested movie as @movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        assigns(:movie).should equal(mock_movie)
      end

      it "should redirect to the movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(movie_url(mock_movie))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "should expose the movie as @movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        assigns(:movie).should equal(mock_movie)
      end

      it "should re-render the 'edit' template" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      mock_movie.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the movies list" do
      Movie.stub!(:find).and_return(mock_movie(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(movies_url)
    end

  end

end
