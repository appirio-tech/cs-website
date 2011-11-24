# Change to wherever the app is hosted, required only for Salesforce, since it does not accept a http:// callback.
OmniAuth.config.full_host = ENV['omniauth_full_host'] 
OmniAuth.config.on_failure = lambda{|env| raise env['omniauth.error']}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['twitter_oauth_key'], ENV['twitter_oauth_secret']          # working
  provider :github, ENV['github_oauth_key'], ENV['github_oauth_secret']             # working
  provider :facebook, ENV['facebook_oauth_key'], ENV['facebook_oauth_secret']       # working -- but not on localhost
  provider :linked_in, ENV['linkedin_oauth_key'], ENV['linkedin_oauth_secret']      # have not tried yet
  provider :salesforce, ENV['sfdc_oauth_key'], ENV['sfdc_oauth_secret']             # does not work -- needs to use a sandbox url in dev & 
  provider :openid, :store => OpenID::Store::ActiveRecord.new
end
