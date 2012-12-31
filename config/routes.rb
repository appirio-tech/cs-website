CloudSpokes::Application.routes.draw do
  
  resources :sessions

  match "/appirio" => redirect("/communities/appirio")
  match 'communities/:community_id', :to => 'communities#show', :as => :community

  match '/signup',  :to => 'sessions#signup'
  match '/signup/:id', :to => 'sessions#signup_referral'
  match '/signup_complete', :to => 'sessions#signup_complete'  
  match '/signup_third_party_create', :to => 'sessions#signup_third_party_create'
  match '/signup_cs_create', :to => 'sessions#signup_cs_create'  
  match '/logout', :to => 'sessions#destroy'  
  match '/login', :to => 'sessions#login' 
  match '/login_popup', :to => 'sessions#login_popup'  
  match '/login_required', :to => 'sessions#login_required'  
  match '/login_cs_auth',  :to => 'sessions#login_cs_auth'
  match "/reset_password"               => "sessions#public_reset_password"
  match "/reset_password_submit"        => "sessions#public_reset_password_submit"  
  match "/forgot_password"              => "sessions#public_forgot_password"
  match "/forgot_password_send"         => "sessions#public_forgot_password_send"
  match "/forgot_service"               => "sessions#forgot_service"
  
  match "/members/order_by_name"        => "members#index", :defaults => { :order_by => 'name' }
  match "/members/order_by_win"         => "members#index", :defaults => { :order_by => 'total_wins' }
  match "/members/order_by_active"      => "members#index", :defaults => { :order_by => 'challenges_entered' }
  match "/members/search"               => "members#search", :as => :members_search
  match "/members/:id/past_challenges"  => "members#past_challenges"
  match "/members/:id/active_challenges"  => "members#active_challenges"  
  match "/members/:id/recommend"        => "members#recommend", :as => :recommend_member
  match "/members/:id/recommend_new"    => "members#recommend_new", :as => :recommend_member_new
  resources :members

  match "account"                       => "accounts#index"
  match "/account/challenges"           => "accounts#challenges"
  match "/account/school"               => "accounts#school"
  match "/account/details"              => "accounts#details"
  match "/account/payments"             => "accounts#payments"
  match "/account/public_profile"       => "accounts#public_profile"  
  match "/account/password"             => "accounts#password"
  match "/account/password_reset"       => "accounts#password_reset", :as => :password_reset
  match "/account/outstanding_reviews"  => "accounts#outstanding_reviews" , :as => :outstanding_reviews
  match '/account/scorecard/:id'        => 'accounts#scorecard'
  match '/account/scorecard_save'       => 'accounts#scorecard_save', :as => :scorecard_save
  match '/account/profile_pic'          => 'accounts#profile_pic', :as => :profile_pic 
  match '/account/communities'          => 'accounts#communities', :as => :my_communities 
  match '/account/invite'               => 'accounts#invite', :as => :invite 
  match '/account/referrals'            => 'accounts#referrals', :as => :referrals 
  match "/account/judging_queue"        => "accounts#judging_queue"
  match "/account/judging/feed"         => "accounts#judging_feed", :as => :judging_feed, :defaults => { :format => 'atom' }  
  match "/account/add_judge/:id"        => "accounts#add_judge"

  # messages
  match "messages"                      => "messages#index", :as => :messages, :via => :get, :type => 'inbox'
  match "messages/inbox"                => "messages#index", :as => :messages_inbox, :via => :get, :type => 'inbox'
  match "messages/sent"                 => "messages#index", :as => :messages_sent, :via => :get, :type => 'sent'  
  match "messages"                      => "messages#create", :as => :messages, :via => :post
  match "messages/:id"                  => "messages#show", :as => :message
  match "messages/:id/reply"            => "messages#reply", :as => :message_reply      

  #challenges
  get "challenges/index"
  match 'challenges', :to => 'challenges#index', :as => :challenges
  match 'challenges/feed', :to => 'challenges#feed', :as => :feed, :defaults => { :format => 'atom' }
  match 'challenges/feed/recent', :to => 'challenges#feed_recent', :as => :feed_recent, :defaults => { :format => 'atom' }
  match 'challenges/recent', :to => 'challenges#recent'
  match 'challenges/:id', :to => 'challenges#show', :as => :challenge
  match 'challenges/:id/edit', :to => 'challenges#edit', :as => :challenge_edit  
  match 'challenges/:id/iframe', :to => 'challenges#iframe', :as => :challenge_iframe
  match 'challenges/:id/preview', :to => 'challenges#preview', :as => :challenge_preview  
  match 'challenges/:id/participants', :to => 'challenges#registrants', :as => :participants
  match 'challenges/:id/register', :to => 'challenges#register', :as => :register
  match 'challenges/:id/agree_to_tos', :to => 'challenges#register_agree_to_tos', :as => :agree_tos
  match 'challenges/:id/results', :to => 'challenges#results', :as => :results
  match 'challenges/:id/survey', :to => 'challenges#survey', :as => :survey
  match 'challenges/:id/preview_survey', :to => 'challenges#preview_survey', :as => :preview_survey  
  match 'challenges/:id/submissions/:participant', :to => 'challenges#participant_submissions', :as => :participant_submissions
  match 'challenges/:id/scorecard/:scorecard/:reviewer/:username', :to => 'challenges#participant_scorecard', :as => :participant_scorecard
  match 'challenges/:id/watch', :to => 'challenges#watch', :as => :watch
  match 'challenges/:id/scorecard', :to => 'challenges#scorecard', :as => :scorecard_display
  match 'challenges/:id/new_comment', :to => 'challenges#new_comment', :as => :challenge_comment 
  match 'challenges/:id/toggle_discussion_email', :to => 'challenges#toggle_discussion_email', :as => :toggle_discussion_email  
  match 'challenges/:id/all_submissions', :to => 'challenges#all_submissions', :as => :all_submissions
  match 'challenges/:id/cal', :to => 'challenges#cal', :as => :cal  
  match 'challenges/:id/submission', :to => 'challenges#submission', :as => :submission
  match 'challenges/:id/submission_view_only', :to => 'challenges#submission_view_only', :as => :submission_view_only
  match 'challenges/:id/submission/url', :to => 'challenges#submission_url_upload', :as => :submission_url, :via => :post
  match 'challenges/:id/submission/file', :to => 'challenges#submission_file_upload', :as => :submission_file, :via => :post
  match 'challenges/:id/submission/url_delete', :to => 'challenges#submission_url_delete', :as => :submission_delete
  match 'leaderboard', :to => 'challenges#leaderboard', :as => 'leaderboards'
  match 'leaderboard_this_month', :to => 'challenges#leaderboard_this_month', :as => 'leaderboard_this_month'
  match 'leaderboard_this_year', :to => 'challenges#leaderboard_this_year', :as => 'leaderboard_this_year'
  match 'leaderboard_all_time', :to => 'challenges#leaderboard_all_time', :as => 'leaderboard_all_time'    
  match "/newbie" => redirect("/challenges?category=Newbie")
  
  # quick quiz
  # match 'quizes/:id/quiz', :to => 'quizes#show', :as => :takequiz
  # match 'quizes/:id/answer', :to => 'quizes#answer', :as => :answerquiz
  match 'quizes/:id/practice', :to => 'quizes#practice', :as => :practicequiz
  match 'quizes/:id/leaderboard', :to => 'quizes#leaderboard', :as => :quizleaderboard
  match 'quizes/:id/results', :to => 'quizes#results', :as => :quizresults
  match 'quizes/:id/results_by_member/:member/:date', :to => 'quizes#results_by_member', :as => :quizresults_by_member
  match 'quizes/answer_by_member/:member', :to => 'quizes#answer_by_member', :as => :quizanswer_by_member  
  match 'quizes/:id/winners', :to => 'quizes#winners', :as => :quizwinners
  match 'quizes/flag_answer/:id', :to => 'quizes#flag_answer', :as => :flag_answer
  match 'quizes/:id/question', :to => 'quizes#fetch_question', :as => :fetchquestion
  
  match '/admin',  :to => 'admin#index'
  get "admin/index"
  get "admin/delete_all_users"
  get "admin/display_settings"
  get "admin/send_mail"
  get "admin/refresh_token"
  get "admin/cache_stats"
  get "admin/stats"
  match 'admin/blogfodder/:id', :to => 'admin#blogfodder'
  get "admin/create_badgeville_users"
  match 'admin/create_badgeville_user/:membername', :to => 'admin#create_badgeville_user'
  match 'admin/update_badgeville_player/:membername', :to => 'admin#update_badgeville_player'
  
  get "admin/update_badgeville_players"
  get 'admin/update_badgeville_player_ids'
  
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/auth/failure', :to => 'sessions#callback_failure' 

  match "/notifications", to: "application#notifications" 
  
  # hacathons
  match 'hackathons/:id', :to => 'hackathons#show', :as => :hackathon
  get "hackathons/results"
  get "hackathons/page"
  
  #content -- eventually will be refinery
  match "/privacy" => redirect("http://content.cloudspokes.com/privacy")
  match "/partners" => redirect("http://content.cloudspokes.com/partners")
  match "/tos" => redirect("http://content.cloudspokes.com/terms-of-service")
  match "/login_help" => redirect("http://content.cloudspokes.com/help-logging-in")
  match "/faq" => redirect("http://community.cloudspokes.com/cloudspokes/products/cloudspokes_faq_s")
  match "/welcome2cloudspokes" => redirect("http://content.cloudspokes.com/welcome2cloudspokes")
  match "/login_denied" => redirect("http://content.cloudspokes.com/login-denied")

  match "/badges", to: "content#badges" # moving to refinery
  match "/home", to: "content#home", :as => :home
  match "/forums", to: "content#forums", :as => :forums
  root to: 'content#home'
  
  mount Resque::Server, :at => "/resque"
  
  # 404 errors
  match '*a', :to => 'errors#routing'
end
