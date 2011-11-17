# Change to wherever the app is hosted, required only for Salesforce, since it does not accept a http:// callback.
OmniAuth.config.full_host = ENV['omniauth_full_host'] 

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :twitter, ENV['twitter_oauth_key'], ENV['twitter_oauth_secret']          # working
  provider :github, ENV['github_oauth_key'], ENV['github_oauth_secret']             # working
  provider :facebook, ENV['facebook_oauth_key'], ENV['facebook_oauth_secret']       # working -- but not on localhost
  provider :linked_in, ENV['linkedin_oauth_key'], ENV['linkedin_oauth_secret']      # have not tried yet
  provider :salesforce, ENV['sfdc_oauth_key'], ENV['sfdc_oauth_secret']             # does not work
  provider :google, "cs-website-sandbox.herokuapp.com", "5WKsvl3O2wzpQtG3k-XnhbqR"  # does not work -- wierd security error
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id' # have not tried yet
end