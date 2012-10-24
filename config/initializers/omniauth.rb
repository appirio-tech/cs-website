OmniAuth.config.full_host = ENV['OMNIAUTH_FULL_HOST'] 

sfdc_setup = lambda do |env|
  env['omniauth.strategy'].options[:client_options][:site] = 'https://test.salesforce.com' if ENV['SFDC_INSTANCE_URL'].eql?('https://cs10.salesforce.com')
end

# comment out this line so errors are caught by SessionController.callback_failure
#OmniAuth.config.on_failure{|env| raise env['omniauth.error'] if env['omniauth.error'] }

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :twitter, ENV['TWITTER_OAUTH_KEY'], ENV['TWITTER_OAUTH_SECRET']
  provider :github, ENV['GITHUB_OAUTH_KEY'], ENV['GITHUB_OAUTH_SECRET']
  provider :facebook, ENV['FACEBOOK_OAUTH_KEY'], ENV['FACEBOOK_OAUTH_SECRET']
  provider :linked_in, ENV['LINKEDIN_OAUTH_KEY'], ENV['LINKEDIN_OAUTH_SECRET']
  provider :salesforce, ENV['SFDC_OAUTH_KEY'], ENV['SFDC_OAUTH_SECRET'], :setup => sfdc_setup
  provider :openid, :store => OpenID::Store::ActiveRecord.new
end
