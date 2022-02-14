source 'http://rubygems.org'

gem 'rails', '5.2.6.2'
gem 'compass', git: 'git://github.com/chriseppstein/compass.git'
gem 'databasedotcom'
gem 'databasedotcom-rails'
gem 'haml'
gem 'will_paginate'
gem 'jquery-rails', '>= 4.0.1'
gem 'httparty'

gem 'ruby-openid', :git => "git://github.com/mbleigh/ruby-openid.git"
gem 'openid_active_record_store', '>= 1.0.1'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'omniauth-openid'
gem 'omniauth-salesforce'
gem 'savon'
gem 'rack-timeout'
gem 'bootstrap-sass'

gem 'redis'
gem 'aws-s3', :require => 'aws/s3'
gem 'thin'
gem 'resque', :git => 'http://github.com/hone/resque.git', :branch => 'keepalive', :require => 'resque/server'
gem "recaptcha", :require => "recaptcha/rails"
gem 'flash_messages_helper'
gem 'remote_syslog_logger'
gem 'dalli'
gem 'encryptor'
gem 'airbrake'

group :development, :test do
  gem 'sqlite3-ruby'
  gem 'rspec-rails', '~> 2.11', '>= 2.11.4'
  gem 'annotate', '2.4.0'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'growl'
  gem 'ruby-debug19'
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
  gem 'sass-rails', '~> 5.0.5'
  gem 'coffee-rails', '~> 4.2.2'
  gem 'uglifier'
end


