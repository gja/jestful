class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
    render :text => :foo, :layout => "application"
  end
end
