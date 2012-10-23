class Endpoint
  class << self

    # Returns the WSDL endpoint for a given +type+ of request.
    def wsdl(type = nil)
      case type
        when :no_namespace       then "http://nons.example.com/Service?wsdl"
        when :namespaced_actions then "http://nsactions.example.com/Service?wsdl"
        when :geotrust           then "https://test-api.geotrust.com/webtrust/query.jws?WSDL"
        else                          soap(type)
      end
    end

    # Returns the SOAP endpoint for a given +type+ of request.
    def soap(type = nil)
      case type
        when :soap_fault then "http://soapfault.example.com/Service?wsdl"
        when :http_error then "http://httperror.example.com/Service?wsdl"
        when :invalid    then "http://invalid.example.com/Service?wsdl"
        else                  "http://example.com/validation/1.0/AuthenticationService"
      end
    end

  end
end
