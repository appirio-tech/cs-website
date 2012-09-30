Resque::Server.use(Rack::Auth::Basic) do |user, password|
  username = ENV['WEB_ADMIN_USERNAME']
  password = ENV['WEB_ADMIN_PASSWORD']
end