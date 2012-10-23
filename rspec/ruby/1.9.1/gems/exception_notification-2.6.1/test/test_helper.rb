# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require "rails/test_help"
require File.expand_path("../dummy/test/test_helper.rb", __FILE__)

Rails.backtrace_cleaner.remove_silencers!
