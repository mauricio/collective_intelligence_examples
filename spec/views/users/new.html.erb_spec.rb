require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/users/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_name[name=?]", "user[name]")
    end
  end
end


