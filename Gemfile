source 'http://rubygems.org'

gem 'rails', '3.1.10'
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
gem 'savon'
gem 'rack-timeout'

# challenge admin -- not exactly sure which are needed?
gem 'sass-rails', '~> 3.1.0'
gem 'bootstrap-sass', '2.1.1.0'
gem 'simple_form', '2.0.4'
gem 'chosen-rails'
gem "select2-rails" # this is WAY better than chosen as it supports loading remote data
gem 'ckeditor_rails', git: 'git://github.com/tsechingho/ckeditor-rails.git'
gem 'plupload-rails', git: 'git://github.com/thatdutchguy/plupload-rails.git'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'awesome_print'
gem 'fog'
gem 'nest'
gem 'text'

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
  gem 'rspec-rails', '~> 2.11'
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
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end


