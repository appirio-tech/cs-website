require 'omniauth'
require 'hashie/mash'

module OmniAuth
  class NoSessionError < StandardError; end
  # The Strategy is the base unit of OmniAuth's ability to
  # wrangle multiple providers. Each strategy provided by
  # OmniAuth includes this mixin to gain the default functionality
  # necessary to be compatible with the OmniAuth library.
  module Strategy
    def self.included(base)
      OmniAuth.strategies << base

      base.extend ClassMethods
      base.class_eval do
        attr_reader :app, :env, :options, :response

        option :setup, false
        option :skip_info, false
      end
    end

    module ClassMethods
      # Returns an inherited set of default options set at the class-level
      # for each strategy.
      def default_options
        return @default_options if @default_options
        existing = superclass.respond_to?(:default_options) ? superclass.default_options : {}
        @default_options = OmniAuth::Strategy::Options.new(existing)
      end

      # This allows for more declarative subclassing of strategies by allowing
      # default options to be set using a simple configure call.
      #
      # @param options [Hash] If supplied, these will be the default options (deep-merged into the superclass's default options).
      # @yield [Options] The options Mash that allows you to set your defaults as you'd like.
      #
      # @example Using a yield to configure the default options.
      #
      #   class MyStrategy
      #     include OmniAuth::Strategy
      #
      #     configure do |c|
      #       c.foo = 'bar'
      #     end
      #   end
      #
      # @example Using a hash to configure the default options.
      #
      #   class MyStrategy
      #     include OmniAuth::Strategy
      #     configure foo: 'bar'
      #   end
      def configure(options = nil)
        yield default_options and return unless options
        default_options.deep_merge!(options)
      end

      # Directly declare a default option for your class. This is a useful from
      # a documentation perspective as it provides a simple line-by-line analysis
      # of the kinds of options your strategy provides by default.
      #
      # @param name [Symbol] The key of the default option in your configuration hash.
      # @param value [Object] The value your object defaults to. Nil if not provided.
      #
      # @example
      #
      #   class MyStrategy
      #     include OmniAuth::Strategy
      #
      #     option :foo, 'bar'
      #     option 
      #   end
      def option(name, value = nil)
        default_options[name] = value
      end

      # Sets (and retrieves) option key names for initializer arguments to be
      # recorded as. This takes care of 90% of the use cases for overriding
      # the initializer in OmniAuth Strategies.
      def args(args = nil)
        @args = Array(args) and return if args
        existing = superclass.respond_to?(:args) ? superclass.args : []
        return @args || existing
      end

      %w(uid info extra credentials).each do |fetcher|
        class_eval <<-RUBY
          def #{fetcher}(&block)
            return @#{fetcher}_proc unless block_given?
            @#{fetcher}_proc = block
          end

          def #{fetcher}_stack(context)
            compile_stack(self.ancestors, :#{fetcher}, context)
          end
        RUBY
      end

      def compile_stack(ancestors, method, context)
        stack = ancestors.inject([]) do |a, ancestor|
          a << context.instance_eval(&ancestor.send(method)) if ancestor.respond_to?(method) && ancestor.send(method)
          a
        end
        stack.reverse!
      end
    end

    # Initializes the strategy by passing in the Rack endpoint,
    # the unique URL segment name for this strategy, and any
    # additional arguments. An `options` hash is automatically
    # created from the last argument if it is a hash.
    #
    # @param app [Rack application] The application on which this middleware is applied.
    #
    # @overload new(app, options = {})
    #   If nothing but a hash is supplied, initialized with the supplied options
    #   overriding the strategy's default options via a deep merge.
    # @overload new(app, *args, options = {})
    #   If the strategy has supplied custom arguments that it accepts, they may
    #   will be passed through and set to the appropriate values.
    #
    # @yield [Options] Yields options to block for further configuration.
    def initialize(app, *args, &block)
      @app = app
      @options = self.class.default_options.dup

      options.deep_merge!(args.pop) if args.last.is_a?(Hash)
      options.name ||= self.class.to_s.split('::').last.downcase

      self.class.args.each do |arg|
        options[arg] = args.shift
      end

      # Make sure that all of the args have been dealt with, otherwise error out.
      raise ArgumentError, "Received wrong number of arguments. #{args.inspect}" unless args.empty?

      yield options if block_given?
    end

    def inspect
      "#<#{self.class.to_s}>"
    end

    # Duplicates this instance and runs #call! on it.
    # @param [Hash] The Rack environment.
    def call(env)
      dup.call!(env)
    end

    # The logic for dispatching any additional actions that need
    # to be taken. For instance, calling the request phase if
    # the request path is recognized.
    #
    # @param env [Hash] The Rack environment.
    def call!(env)
      raise OmniAuth::NoSessionError.new("You must provide a session to use OmniAuth.") unless env['rack.session']

      @env = env
      @env['omniauth.strategy'] = self if on_auth_path?

      return mock_call!(env) if OmniAuth.config.test_mode

      return options_call if on_auth_path? && options_request?
      return request_call if on_request_path? && OmniAuth.config.allowed_request_methods.include?(request.request_method.downcase.to_sym)
      return callback_call if on_callback_path?
      return other_phase if respond_to?(:other_phase)
      @app.call(env)
    end

    # Responds to an OPTIONS request.
    def options_call
      verbs = OmniAuth.config.allowed_request_methods.map(&:to_s).map(&:upcase).join(', ')
      return [ 200, { 'Allow' => verbs }, [] ]
    end

    # Performs the steps necessary to run the request phase of a strategy.
    def request_call
      setup_phase

      #store query params from the request url, extracted in the callback_phase
      session['omniauth.params'] = request.params

      if options.form.respond_to?(:call)
        options.form.call(env)
      elsif options.form
        call_app!
      else
        if request.params['origin']
          env['rack.session']['omniauth.origin'] = request.params['origin']
        elsif env['HTTP_REFERER'] && !env['HTTP_REFERER'].match(/#{request_path}$/)
          env['rack.session']['omniauth.origin'] = env['HTTP_REFERER']
        end
        request_phase
      end
    end

    # Performs the steps necessary to run the callback phase of a strategy.
    def callback_call
      setup_phase
      @env['omniauth.origin'] = session.delete('omniauth.origin')
      @env['omniauth.origin'] = nil if env['omniauth.origin'] == ''
      @env['omniauth.params'] = session.delete('omniauth.params') || {}
      callback_phase
    end

    # Returns true if the environment recognizes either the 
    # request or callback path.
    def on_auth_path?
      on_request_path? || on_callback_path?
    end

    def on_request_path?
      on_path?(request_path)
    end

    def on_callback_path?
      on_path?(callback_path)
    end

    def on_path?(path)
      current_path.casecmp(path) == 0
    end

    def options_request?
      request.request_method == 'OPTIONS'
    end

    # This is called in lieu of the normal request process
    # in the event that OmniAuth has been configured to be
    # in test mode.
    def mock_call!(env)
      return mock_request_call if on_request_path?
      return mock_callback_call if on_callback_path?
      call_app!
    end

    def mock_request_call
      setup_phase
      return response if response = call_through_to_app

      if request.params['origin']
        @env['rack.session']['omniauth.origin'] = request.params['origin']
      elsif env['HTTP_REFERER'] && !env['HTTP_REFERER'].match(/#{request_path}$/)
        @env['rack.session']['omniauth.origin'] = env['HTTP_REFERER']
      end
      redirect(script_name + callback_path + query_string)
    end

    def mock_callback_call
      setup_phase
      mocked_auth = OmniAuth.mock_auth_for(name.to_s)
      if mocked_auth.is_a?(Symbol)
        fail!(mocked_auth)
      else
        @env['omniauth.auth'] = mocked_auth
        @env['omniauth.params'] = session.delete('query_params') || {}
        @env['omniauth.origin'] = session.delete('omniauth.origin')
        @env['omniauth.origin'] = nil if env['omniauth.origin'] == ''
        call_app!
      end
    end

    # The setup phase looks for the `:setup` option to exist and,
    # if it is, will call either the Rack endpoint supplied to the
    # `:setup` option or it will call out to the setup path of the
    # underlying application. This will default to `/auth/:provider/setup`.
    def setup_phase
      if options[:setup].respond_to?(:call)
        options[:setup].call(env)
      elsif options.setup?
        setup_env = env.merge('PATH_INFO' => setup_path, 'REQUEST_METHOD' => 'GET')
        call_app!(setup_env)
      end
    end

    # @abstract This method is called when the user is on the request path. You should
    # perform any information gathering you need to be able to authenticate
    # the user in this phase.
    def request_phase
      raise NotImplementedError
    end

    def uid
      self.class.uid_stack(self).last
    end

    def info
      merge_stack(self.class.info_stack(self))
    end

    def credentials
      merge_stack(self.class.credentials_stack(self))
    end

    def extra
      merge_stack(self.class.extra_stack(self))
    end

    def auth_hash
      hash = AuthHash.new(:provider => name, :uid => uid)
      hash.info = info unless skip_info?
      hash.credentials = credentials if credentials
      hash.extra = extra if extra
      hash
    end

    # Determines whether or not user info should be retrieved. This
    # allows some strategies to save a call to an external API service
    # for existing users. You can use it either by setting the `:skip_info`
    # to true or by setting `:skip_info` to a Proc that takes a uid and
    # evaluates to true when you would like to skip info.
    #
    # @example
    #
    #   use MyStrategy, :skip_info => lambda{|uid| User.find_by_uid(uid)}
    def skip_info?
      if options.skip_info?
        if options.skip_info.respond_to?(:call)
          return options.skip_info.call(uid)
        else
          return true
        end
      end
      false
    end

    def callback_phase
      self.env['omniauth.auth'] = auth_hash
      call_app!
    end

    def path_prefix
      options[:path_prefix] || OmniAuth.config.path_prefix
    end

    def request_path
      options[:request_path] || "#{path_prefix}/#{name}"
    end

    def callback_path
      options[:callback_path] || "#{path_prefix}/#{name}/callback"
    end

    def setup_path
      options[:setup_path] || "#{path_prefix}/#{name}/setup"
    end

    def current_path
      request.path_info.downcase.sub(/\/$/,'')
    end

    def query_string
      request.query_string.empty? ? "" : "?#{request.query_string}"
    end

    def call_through_to_app
      status, headers, body = *call_app!
      session['query_params'] = Rack::Request.new(env).params
      @response = Rack::Response.new(body, status, headers)

      status == 404 ? nil : @response.finish
    end

    def call_app!(env = @env)
      @app.call(env)
    end

    def full_host
      case OmniAuth.config.full_host
        when String
          OmniAuth.config.full_host
        when Proc
          OmniAuth.config.full_host.call(env)
        else
          uri = URI.parse(request.url.gsub(/\?.*$/,''))
          uri.path = ''
          uri.query = nil
          uri.to_s
      end
    end

    def callback_url
      full_host + script_name + callback_path + query_string
    end

    def script_name
      @env['SCRIPT_NAME'] || ''
    end

    def session
      @env['rack.session']
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def name
      options.name
    end

    def redirect(uri)
      r = Rack::Response.new

      if options[:iframe]
        r.write("<script type='text/javascript' charset='utf-8'>top.location.href = '#{uri}';</script>")
      else
        r.write("Redirecting to #{uri}...")
        r.redirect(uri)
      end

      r.finish
    end

    def user_info; {} end

    def fail!(message_key, exception = nil)
      self.env['omniauth.error'] = exception
      self.env['omniauth.error.type'] = message_key.to_sym
      self.env['omniauth.error.strategy'] = self

      OmniAuth.config.on_failure.call(self.env)
    end

    class Options < Hashie::Mash; end

    protected

    def merge_stack(stack)
      stack.inject({}){|c,h| c.merge!(h); c}
    end
  end
end
