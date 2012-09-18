source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'compass', git: 'git://github.com/chriseppstein/compass.git'
gem 'databasedotcom'
gem 'databasedotcom-rails'
gem 'haml'
gem 'will_paginate'
gem 'jquery-rails'
gem 'httparty'

gem 'ruby-openid', :git => "git://github.com/mbleigh/ruby-openid.git"
gem 'openid_active_record_store'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'omniauth-openid'
gem 'omniauth-salesforce'

gem 'redis'
gem 'aws-s3', :require => 'aws/s3'
gem 'thin'
gem 'resque', :git => 'http://github.com/hone/resque.git', :branch => 'keepalive', :require => 'resque/server'
gem "recaptcha", :require => "recaptcha/rails"
gem 'flash_messages_helper'
gem 'remote_syslog_logger'
gem 'dalli'
gem 'exception_notification'

group :development, :test do
  gem 'sqlite3-ruby'
  gem 'rspec-rails', '~> 2.6'
  gem 'annotate', '2.4.0'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem "guard-spork"
  gem 'guard-cucumber'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'ruby-debug19'
  gem 'heroku'

  gem 'spork'
  gem 'factory_girl'
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'

  gem 'capybara'
  gem 'timecop'
  gem 'webmock'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem "minitest"
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end


