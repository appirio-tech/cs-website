OmniAuth.config.full_host = ENV['OMNIAUTH_FULL_HOST'] 

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :twitter, ENV['TWITTER_OAUTH_KEY'], ENV['TWITTER_OAUTH_SECRET']
  provider :github, ENV['GITHUB_OAUTH_KEY'], ENV['GITHUB_OAUTH_SECRET']
  provider :facebook, ENV['FACEBOOK_OAUTH_KEY'], ENV['FACEBOOK_OAUTH_SECRET']
  provider :linked_in, ENV['LINKEDIN_OAUTH_KEY'], ENV['LINKEDIN_OAUTH_SECRET']
  provider :salesforce, ENV['SFDC_OAUTH_KEY'], ENV['SFDC_OAUTH_SECRET']
  provider :openid, :store => OpenID::Store::ActiveRecord.new
end
