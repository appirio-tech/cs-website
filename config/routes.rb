CloudSpokes::Application.routes.draw do
  
  resources :users

  match '/signup',  :to => 'sessions#signup'
  match '/signup_complete', :to => 'sessions#signup_third_party_no_email'  
  match '/signup_third_party_create', :to => 'sessions#signup_third_party_create'
  match '/logout', :to => 'sessions#destroy'  
  match '/login', :to => 'sessions#login'  
  match '/login_cs_auth',  :to => 'sessions#login_cs_auth'
  match "/reset_password"               => "sessions#public_reset_password"
  match "/reset_password_submit"        => "sessions#public_reset_password_submit"  
  match "/forgot_password"              => "sessions#public_forgot_password"
  match "/forgot_password_send"         => "sessions#public_forgot_password_send"
  resources :sessions
  
  match "/members/order_by_name"        => "members#index", :defaults => { :order_by => 'name' }
  match "/members/order_by_win"         => "members#index", :defaults => { :order_by => 'total_wins__c' }
  match "/members/order_by_active"      => "members#index", :defaults => { :order_by => 'challenges_entered__c' }
  match "/members/search"               => "members#search", :as => :members_search
  match "/members/:id/past_challenges"  => "members#past_challenges"
  match "/members/:id/recommend"        => "members#recommend", :as => :recommend_member
  match "/members/:id/recommend_new"    => "members#recommend_new", :as => :recommend_member_new
  resources :members

  match "account"                       => "accounts#index"
  match "/account/challenges"           => "accounts#challenges"
  match "/account/school"               => "accounts#school"
  match "/account/details"              => "accounts#details"
  match "/account/payments"              => "accounts#payments"
  match "/account/public_profile"       => "accounts#public_profile"  
  match "/account/password"             => "accounts#password"
  match "/account/password_reset"       => "accounts#password_reset", :as => :password_reset
  match "/account/outstanding_reviews"  => "accounts#outstanding_reviews" 
  match '/account/scorecard/:id'        => 'accounts#scorecard'
  post "/account/scorecard_save"

  #challenges
  get "challenges/index"
  match 'challenges', :to => 'challenges#index', :as => :challenges
  match 'challenges/recent', :to => 'challenges#recent'
  match 'challenges/:id', :to => 'challenges#show', :as => :challenge
  match 'challenges/:id/registrants', :to => 'challenges#registrants', :as => :registrants
  match 'challenges/:id/register', :to => 'challenges#register'
  match 'challenges/:id/agree_to_tos', :to => 'challenges#register_agree_to_tos', :as => :agree_tos
  match 'challenges/:id/results', :to => 'challenges#results', :as => :results
  match 'challenges/:id/watch', :to => 'challenges#watch' 
  match 'challenges/:id/scorecard', :to => 'challenges#scorecard'
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
  get "test/send_mail"
  get "test/profile_pic"
  post "test/profile_pic"  
  
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/auth/failure', :to => 'sessions#callback_failure'  
  
  #content -- eventually will be siteforce
  #match "/:id", to: "content#show", as: "content"
  match "/about", to: "content#about"
  match "/faq", to: "content#faq"
  match "/privacy", to: "content#privacy"
  match "/tos", to: "content#tos"
  match "/badges", to: "content#badges"
  match "/contact", to: "content#contact"
  match "/contact_send", to: "content#contact_send"
  root to: 'content#home'

  mount Resque::Server, :at => "/resque"
end
