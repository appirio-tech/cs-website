require 'cgi'
require 'uri'
require 'oauth2'
require 'omniauth'

module OmniAuth
  module Strategies
    # Authentication strategy for connecting with APIs constructed using
    # the [OAuth 2.0 Specification](http://tools.ietf.org/html/draft-ietf-oauth-v2-10).
    # You must generally register your application with the provider and
    # utilize an application id and secret in order to authenticate using
    # OAuth 2.0.
    class OAuth2
      include OmniAuth::Strategy

      args [:client_id, :client_secret]

      option :client_id, nil
      option :client_secret, nil
      option :client_options, {}
      option :authorize_params, {}
      option :authorize_options, [:scope]
      option :token_params, {}
      option :token_options, []

      attr_accessor :access_token

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, options.client_options.inject({}){|h,(k,v)| h[k.to_sym] = v; h})
      end

      def callback_url
        full_host + script_name + callback_path
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.expires? && access_token.refresh_token
        hash.merge!('expires_at' => access_token.expires_at) if access_token.expires?
        hash.merge!('expires' => access_token.expires?)
        hash
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        options.authorize_params.merge(options.authorize_options.inject({}){|h,k| h[k.to_sym] = options[k] if options[k]; h})
      end

      def token_params
        options.token_params.merge(options.token_options.inject({}){|h,k| h[k.to_sym] = options[k] if options[k]; h})
      end

      def callback_phase
        if request.params['error'] || request.params['error_reason']
          raise CallbackError.new(request.params['error'], request.params['error_description'] || request.params['error_reason'], request.params['error_uri'])
        end

        self.access_token = build_access_token
        self.access_token = client.auth_code.refresh_token(access_token.refresh_token) if access_token.expired?

        super
      rescue ::OAuth2::Error, CallbackError => e
        fail!(:invalid_credentials, e)
      rescue ::MultiJson::DecodeError => e
        fail!(:invalid_response, e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
        fail!(:timeout, e)
      end

      protected

      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(options.token_params.to_hash(:symbolize_keys => true)))
      end

      # An error that is indicated in the OAuth 2.0 callback.
      # This could be a `redirect_uri_mismatch` or other
      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(error, error_reason=nil, error_uri=nil)
          self.error = error
          self.error_reason = error_reason
          self.error_uri = error_uri
        end
      end
    end
  end
end
OmniAuth.config.add_camelization 'oauth2', 'OAuth2'
