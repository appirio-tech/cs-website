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
  match "/members/search"             => "members#search", :as => :members_search
  match "/members/:id/past_challenges"    => "members#past_challenges"
  match "/members/:id/recommend"  => "members#recommend", :as => :recommend_member
  match "/members/:id/recommend_new"  => "members#recommend_new", :as => :recommend_member_new
  resources :members

  match "account"                     => "accounts#index"
  match "/account/challenges"     => "accounts#challenges"
  match "/account/school"         => "accounts#school"
  match "/account/details"        => "accounts#details"
  match "/account/password"       => "accounts#password"
  match "/account/password_reset" => "accounts#password_reset", :as => :password_reset

  match "/reset_password"             => "accounts#public_reset_password"
  match "/forgot_password"           => "accounts#public_forgot_password"
    
  # scoring
  match 'scoring', :to => 'scoring#index'  
  get "scoring/index"
  post "scoring/save"
  match 'scoring/scorecard/:id', :to => 'scoring#scorecard'

  #challenges
  get "challenges/index"
  match 'challenges', :to => 'challenges#index', :as => :challenges
  match 'challenges/:id', :to => 'challenges#show', :as => :challenge
  match 'challenges/:id/registrants', :to => 'challenges#registrants', :as => :registrants
  match 'challenges/:id/register', :to => 'challenges#register'
  match 'challenges/:id/results', :to => 'challenges#results', :as => :results
  match 'challenges/:id/watch', :to => 'challenges#watch' 
  match 'challenges/:id/new_comment', :to => 'challenges#new_comment', :as => :challenge_comment 
  match 'challenges/:id/submission', :to => 'challenges#submission'
  match 'challenges/:id/submission/url', :to => 'challenges#submission_url', :as => :submission_url
  match 'challenges/:id/submission/file', :to => 'challenges#submission_file', :as => :submission_file
  match 'challenges/:id/submission/url_delete', :to => 'challenges#submission_url_delete', :as => :submission_delete
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
  get "test/s3"
  
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/auth/failure', :to => 'sessions#callback_failure'  
  
  #content -- eventually will be siteforce
  #match "/:id", to: "content#show", as: "content"
  match "/about", to: "content#about"
  match "/faq", to: "content#faq"
  match "/privacy", to: "content#privacy"
  match "/tos", to: "content#tos"
  match "/fail", to: "content#fail"
  match "/contact", to: "content#contact"
  match "/contact_send", to: "content#contact_send"
  root to: 'content#home'

end
