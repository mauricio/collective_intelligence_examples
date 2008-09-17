# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def partial( partial_name, locals = {} )
    render :partial => partial_name.to_s, :locals => locals
  end

end
