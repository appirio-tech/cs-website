CloudSpokes::Application.routes.draw do
  get "account/index"

  resources :users
  resources :sessions, :only => [:new, :new_third_party, :create, :create_third_party, :destroy]
  
  match '/signin',  :to => 'sessions#new'
  match '/signup',  :to => 'users#new'
  match '/signup_complete', :to => 'sessions#signup_third_party_no_email'  
  match '/signup_third_party_create', :to => 'sessions#signup_third_party_create'
  
  match '/logout', :to => 'sessions#destroy'  
  match '/login', :to => 'sessions#login'  
  
  match '/account', :to => 'account#index'  
  get "account/index"
  get "account/details"
  get "account/schoolwork"
  post "account/save"

  match '/challenges', :to => 'challenges#index' 
  get "challenges/index"
  
  # tests
  get "test/index"
  get "test/service_sfdc_username"
  get "test/service_new_member_cloudsppokes"
  get "test/get_current_access_token"
  get "test/auth_cloudspokes"
  get "test/auth_thirdparty"
  get "test/display_users"
  get "test/display_settings"
  get "test/dump_env"
  
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/auth/failure', :to => 'sessions#callback_failure'  
  
  match "/:id", to: "content#show", as: "content"
  
  root to: 'content#show', id: 'home'

end
