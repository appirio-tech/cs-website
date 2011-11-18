# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CloudSpokes::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :port           => '25',
  :address        => 'smtp.sendgrid.net',
  :authentication => :plain,
  :user_name      => "app1527003@heroku.com",
  :password       => "bmx6eot3",
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp

if ENV['REDISTOGO_URL']
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  $redis = Redis.new
end


