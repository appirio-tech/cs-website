Resque::Server.use(Rack::Auth::Basic) do |user, password|
  username = ENV['MAILER_USERNAME']
  password = ENV['MAILER_PASSWORD']
end