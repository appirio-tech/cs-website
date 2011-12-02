# Change to wherever the app is hosted, required only for Salesforce, since it does not accept a http:// callback.
OmniAuth.config.full_host = ENV['OMNIAUTH_FULL_HOST'] 

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :twitter, ENV['TWITTER_OAUTH_KEY'], ENV['TWITTER_OAUTH_SECRET']          # working
  provider :github, ENV['GITHUB_OAUTH_KEY'], ENV['GITHUB_OAUTH_SECRET']             # working
  provider :facebook, ENV['FACEBOOK_OAUTH_KEY'], ENV['FACEBOOK_OAUTH_SECRET']       # working -- but not on localhost
  provider :linked_in, ENV['LINKEDIN_OAUTH_KEY'], ENV['LINKEDIN_OAUTH_SECRET']      # have not tried yet
  provider :salesforce, ENV['SFDC_OAUTH_KEY'], ENV['sfdc_oauth_secret']             # does not work -- needs to use a sandbox url in dev & 
  provider :google, "cs-website-sandbox.herokuapp.com", "5WKsvl3O2wzpQtG3k-XnhbqR"  # does not work -- wierd security error
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id' # have not tried yet
end