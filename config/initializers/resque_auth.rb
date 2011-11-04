Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password = "changeme"
end