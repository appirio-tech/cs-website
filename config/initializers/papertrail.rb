if ENV["SYSLOG_URL"]
  require "remote_syslog_logger"
  require "uri"

  url = URI.parse(ENV["SYSLOG_URL"])

  logger = RemoteSyslogLogger.new(url.host, url.port, :program => url.path[1..-1])
  logger.level = Logger::INFO

  Rails.logger = Rails.application.config.logger = ActionController::Base.logger = Rails.cache.logger = logger
end