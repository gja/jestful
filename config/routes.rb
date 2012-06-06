Jestful::Application.routes.draw do
  root :to => "application#home"
  get :get, :controller => "application", :action => "get"
  get :redirect, :controller => "application", :action => "redirect"
end
