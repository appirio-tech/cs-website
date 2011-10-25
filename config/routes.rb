CloudSpokes::Application.routes.draw do

  resources :users
  resources :sessions
  
  match '/signup',  :to => 'users#new'
  match '/signup_complete', :to => 'sessions#signup_third_party_no_email'  
  match '/signup_third_party_create', :to => 'sessions#signup_third_party_create'
  
  match '/logout', :to => 'sessions#destroy'  
  match '/login', :to => 'sessions#login'  
  match '/login_cs',  :to => 'sessions#login_cs'
  match '/login_cs_auth',  :to => 'sessions#login_cs_auth'
  
  match '/account', :to => 'account#index'  
  get "account/index"
  get "account/details"
  get "account/schoolwork"
  post "account/save"
  
  # scoring
  match 'scoring', :to => 'scoring#index'  
  get "scoring/index"
  post "scoring/save"
  match 'scoring/scorecard/:id', :to => 'scoring#scorecard'

  #challenges
  get "challenges/index"
  match 'challenges', :to => 'challenges#index' 
  match 'challenges/:id', :to => 'challenges#detail'
  match 'challenges/:id/registrants', :to => 'challenges#registrants'
  match 'leaderboard', :to => 'challenges#leaderboard'
  
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
  
  match '/fail', :to => 'content#fail'
  
  match "/:id", to: "content#show", as: "content"
  
  root to: 'content#show', id: 'home'

end
