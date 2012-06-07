class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
    render :text => :foo, :layout => "application"
  end

  def get
    render :text => "success"
  end

  def redirect
    redirect_to get_url
  end

  def not_found
    head :status => :not_found
  end

  def json
    render :json => {:foo => 'bar'}
  end
end
