CloudSpokes::Application.routes.draw do

  match '/signup',  :to => 'users#new'
  resources :users

  match '/signup_complete', :to => 'sessions#signup_third_party_no_email'  
  match '/signup_third_party_create', :to => 'sessions#signup_third_party_create'
  
  match '/logout', :to => 'sessions#destroy'  
  match '/login', :to => 'sessions#login'  
  match '/login_cs',  :to => 'sessions#login_cs'
  match '/login_cs_auth',  :to => 'sessions#login_cs_auth'
  resources :sessions
  
  match "/members/order_by_name"      => "members#index", :defaults => { :order_by => 'name' }
  match "/members/order_by_win"       => "members#index", :defaults => { :order_by => 'total_wins__c' }
  match "/members/order_by_active"    => "members#index", :defaults => { :order_by => 'challenges_entered__c' }
  match "/members/search"             => "members#search"
  match "/members/:id/past_challenges"    => "members#past_challenges"
  match "/members/:id/active_challenges"  => "members#active_challenges"
  resources :members

  match "/account/:id/challenges"     => "accounts#challenges"
  match "/account/:id/school"         => "accounts#school"
  match "/account/:id/details"        => "accounts#details"
  match "/account/:id/password"       => "accounts#password"
  # match '/account', :to => 'account#index'  
  # get "account/index"
  # get "account/details"
  # get "account/schoolwork"
  # post "account/save"

  match "/reset_password"             => "accounts#reset_password"
  match "/require_password"           => "accounts#require_password"
    
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
