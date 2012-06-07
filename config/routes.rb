Jestful::Application.routes.draw do
  root :to => "application#home"

  scope 'test', :controller => "application" do
    get :get
    get :redirect
    get :not_found
    get :json
    get :return_foo
  end
end
