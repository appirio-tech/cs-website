require 'forcedotcom'

module OmniAuth
  module Strategies
    #tell omniauth to load our strategy
    autoload :Forcedotcom, 'lib/forcedotcom'
  end
end

# Change to wherever the app is hosted, required only for Salesforce, since it does not accept a http:// callback.
OmniAuth.config.full_host = ENV['omniauth_full_host'] 

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :twitter, ENV['twitter_oauth_key'], ENV['twitter_oauth_secret']
  provider :github, ENV['github_oauth_key'], ENV['github_oauth_secret']
  provider :facebook, ENV['facebook_oauth_key'], ENV['facebook_oauth_secret']
  provider :linked_in, ENV['linkedin_oauth_key'], ENV['linkedin_oauth_secret']
  provider :salesforce, ENV['sfdc_oauth_key'], ENV['sfdc_oauth_secret']
  provider :forcedotcom, ENV['sfdc_oauth_key'], ENV['sfdc_oauth_secret']
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end