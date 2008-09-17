require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/index.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:users] = [
      stub_model(User,
        :name => "value for name"
      ),
      stub_model(User,
        :name => "value for name"
      )
    ]
  end

  it "should render list of users" do
    render "/users/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

