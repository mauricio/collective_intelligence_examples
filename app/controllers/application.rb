# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e975867b8e63a2a60b1c9c3a721f0796'

  def paginate_model( model, options = {} )
    @page = params[:page] || '1'
    @per_page = params[:per_page] || '20'
    model.paginate( options.merge( :page => @page, :per_page => @per_page ) )
  end


  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
