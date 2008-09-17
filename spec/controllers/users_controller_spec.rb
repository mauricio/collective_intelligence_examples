require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all users as @users" do
      User.should_receive(:find).with(:all).and_return([mock_user])
      get :index
      assigns[:users].should == [mock_user]
    end

    describe "with mime type of xml" do
  
      it "should render all users as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        User.should_receive(:find).with(:all).and_return(users = mock("Array of Users"))
        users.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested user as @user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      get :show, :id => "37"
      assigns[:user].should equal(mock_user)
    end
    
    describe "with mime type of xml" do

      it "should render the requested user as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new user as @user" do
      User.should_receive(:new).and_return(mock_user)
      get :new
      assigns[:user].should equal(mock_user)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested user as @user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      get :edit, :id => "37"
      assigns[:user].should equal(mock_user)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created user as @user" do
        User.should_receive(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(mock_user)
      end

      it "should redirect to the created user" do
        User.stub!(:new).and_return(mock_user(:save => true))
        post :create, :user => {}
        response.should redirect_to(user_url(mock_user))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(mock_user)
      end

      it "should re-render the 'new' template" do
        User.stub!(:new).and_return(mock_user(:save => false))
        post :create, :user => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "should expose the requested user as @user" do
        User.stub!(:find).and_return(mock_user(:update_attributes => true))
        put :update, :id => "1"
        assigns(:user).should equal(mock_user)
      end

      it "should redirect to the user" do
        User.stub!(:find).and_return(mock_user(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(user_url(mock_user))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "should expose the user as @user" do
        User.stub!(:find).and_return(mock_user(:update_attributes => false))
        put :update, :id => "1"
        assigns(:user).should equal(mock_user)
      end

      it "should re-render the 'edit' template" do
        User.stub!(:find).and_return(mock_user(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      mock_user.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the users list" do
      User.stub!(:find).and_return(mock_user(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(users_url)
    end

  end

end
