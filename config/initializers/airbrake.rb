Airbrake.configure do |config|
  config.api_key = 'd586bd84b9ddec9600ca8568335b79df'
  config.logger = Logger.new("#{Rails.root}/log/airbrake.log")

  config.ignore_user_agent  << /Googlebot/  
end
