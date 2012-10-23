module Databasedotcom
  # An exception raised when any non successful request is made to Force.com.
  class SalesForceError < StandardError
    # the Net::HTTPResponse from the API call
    attr_accessor :response
    # the +errorCode+ from the server response body
    attr_accessor :error_code

    def initialize(response)
      self.response = response
      parsed_body = JSON.parse(response.body) rescue nil
      if parsed_body
        if parsed_body.is_a?(Array)
          message = parsed_body[0]["message"]
          self.error_code = parsed_body[0]["errorCode"]
        else
          message = parsed_body["error_description"]
          self.error_code = parsed_body["error"]
        end
      else
        message = response.body
      end
      super(message)
    end
  end
end