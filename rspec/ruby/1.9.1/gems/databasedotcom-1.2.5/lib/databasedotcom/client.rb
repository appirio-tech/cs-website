require 'net/https'
require 'json'
require 'net/http/post/multipart'
require 'date'

module Databasedotcom
  # Interface for operating the Force.com REST API
  class Client
    # The client id (aka "Consumer Key") to use for OAuth2 authentication
    attr_accessor :client_id
    # The client secret (aka "Consumer Secret" to use for OAuth2 authentication)
    attr_accessor :client_secret
    # The OAuth access token in use by the client
    attr_accessor :oauth_token
    # The OAuth refresh token in use by the client
    attr_accessor :refresh_token
    # The base URL to the authenticated user's SalesForce instance
    attr_accessor :instance_url
    # If true, print API debugging information to stdout. Defaults to false.
    attr_accessor :debugging
    # The host to use for OAuth2 authentication. Defaults to +login.salesforce.com+
    attr_accessor :host
    # The API version the client is using. Defaults to 23.0
    attr_accessor :version
    # A Module in which to materialize Sobject classes. Defaults to the global module (Object)
    attr_accessor :sobject_module
    # The SalesForce user id of the authenticated user
    attr_reader :user_id
    # The SalesForce username
    attr_accessor :username
    # The SalesForce password
    attr_accessor :password
    # The SalesForce organization id for the authenticated user's Salesforce instance
    attr_reader :org_id
    # The CA file configured for this instance, if any
    attr_accessor :ca_file
    # The SSL verify mode configured for this instance, if any
    attr_accessor :verify_mode

    # Returns a new client object. _options_ can be one of the following
    #
    # * A String containing the name of a YAML file formatted like:
    #    ---
    #    client_id: <your_salesforce_client_id>
    #    client_secret: <your_salesforce_client_secret>
    #    host: login.salesforce.com
    #    debugging: true
    #    version: 23.0
    #    sobject_module: My::Module
    #    ca_file: some/ca/file.cert
    #    verify_mode: OpenSSL::SSL::VERIFY_PEER
    # * A Hash containing the following keys:
    #    client_id
    #    client_secret
    #    host
    #    debugging
    #    version
    #    sobject_module
    #    ca_file
    #    verify_mode
    # If the environment variables DATABASEDOTCOM_CLIENT_ID, DATABASEDOTCOM_CLIENT_SECRET, DATABASEDOTCOM_HOST,
    # DATABASEDOTCOM_DEBUGGING, DATABASEDOTCOM_VERSION, DATABASEDOTCOM_SOBJECT_MODULE, DATABASEDOTCOM_CA_FILE, and/or 
    # DATABASEDOTCOM_VERIFY_MODE are present, they override any other values provided
    def initialize(options = {})
      if options.is_a?(String)
        @options = YAML.load_file(options)
        @options["verify_mode"] = @options["verify_mode"].constantize if @options["verify_mode"] && @options["verify_mode"].is_a?(String)
      else
        @options = options
      end
      @options.symbolize_keys!

      if ENV['DATABASE_COM_URL']
        url = URI.parse(ENV['DATABASE_COM_URL'])
        url_options = Hash[url.query.split("&").map{|q| q.split("=")}].symbolize_keys!
        self.host = url.host
        self.client_id = url_options[:oauth_key]
        self.client_secret = url_options[:oauth_secret]
        self.username = url_options[:user]
        self.password = url_options[:password]
      else
        self.client_id = ENV['DATABASEDOTCOM_CLIENT_ID'] || @options[:client_id]
        self.client_secret = ENV['DATABASEDOTCOM_CLIENT_SECRET'] || @options[:client_secret]
        self.host = ENV['DATABASEDOTCOM_HOST'] || @options[:host] || "login.salesforce.com"
      end
      
      self.debugging = ENV['DATABASEDOTCOM_DEBUGGING'] || @options[:debugging]
      self.version = ENV['DATABASEDOTCOM_VERSION'] || @options[:version]
      self.version = self.version.to_s if self.version
      self.sobject_module = ENV['DATABASEDOTCOM_SOBJECT_MODULE'] || @options[:sobject_module]
      self.ca_file = ENV['DATABASEDOTCOM_CA_FILE'] || @options[:ca_file]
      self.verify_mode = ENV['DATABASEDOTCOM_VERIFY_MODE'] || @options[:verify_mode]
      self.verify_mode = self.verify_mode.to_i if self.verify_mode
  end

    # Authenticate to the Force.com API.  _options_ is a Hash, interpreted as follows:
    #
    # * If _options_ contains the keys <tt>:username</tt> and <tt>:password</tt>, those credentials are used to authenticate. In this case, the value of <tt>:password</tt> may need to include a concatenated security token, if required by your Salesforce org
    # * If _options_ contains the key <tt>:provider</tt>, it is assumed to be the hash returned by Omniauth from a successful web-based OAuth2 authentication
    # * If _options_ contains the keys <tt>:token</tt> and <tt>:instance_url</tt>, those are assumed to be a valid OAuth2 token and instance URL for a Salesforce account, obtained from an external source. _options_ may also optionally contain the key <tt>:refresh_token</tt>
    #
    # Raises SalesForceError if an error occurs
    def authenticate(options = nil)
      if user_and_pass?(options)
        req = https_request(self.host)
        user = self.username || options[:username]
        pass = self.password || options[:password]
        path = "/services/oauth2/token?grant_type=password&client_id=#{self.client_id}&client_secret=#{client_secret}&username=#{user}&password=#{pass}"
        log_request("https://#{self.host}/#{path}")
        result = req.post(path, "")
        log_response(result)
        raise SalesForceError.new(result) unless result.is_a?(Net::HTTPOK)
        self.username = user
        self.password = pass
        parse_auth_response(result.body)
      elsif options.is_a?(Hash)
        if options.has_key?("provider")
          parse_user_id_and_org_id_from_identity_url(options["uid"])
          self.instance_url = options["credentials"]["instance_url"]
          self.oauth_token = options["credentials"]["token"]
          self.refresh_token = options["credentials"]["refresh_token"]
        else
          raise ArgumentError unless options.has_key?(:token) && options.has_key?(:instance_url)
          self.instance_url = options[:instance_url]
          self.oauth_token = options[:token]
          self.refresh_token = options[:refresh_token]
        end
      end

      self.version = "22.0" unless self.version

      self.oauth_token
    end

    # The SalesForce organization id for the authenticated user's Salesforce instance
    def org_id
      @org_id ||= query_org_id # lazy query org_id when not set by login response
    end

    # Returns an Array of Strings listing the class names for every type of _Sobject_ in the database. Raises SalesForceError if an error occurs.
    def list_sobjects
      result = http_get("/services/data/v#{self.version}/sobjects")
      if result.is_a?(Net::HTTPOK)
        JSON.parse(result.body)["sobjects"].collect { |sobject| sobject["name"] }
      elsif result.is_a?(Net::HTTPBadRequest)
        raise SalesForceError.new(result)
      end
    end

    # Dynamically defines classes for Force.com class names.  _classnames_ can be a single String or an Array of Strings.  Returns the class or Array of classes defined.
    #
    #    client.materialize("Contact") #=> Contact
    #    client.materialize(%w(Contact Company)) #=> [Contact, Company]
    #
    # The classes defined by materialize derive from Sobject, and have getters and setters defined for all the attributes defined by the associated Force.com Sobject.
    def materialize(classnames)
      classes = (classnames.is_a?(Array) ? classnames : [classnames]).collect do |clazz|
        original_classname = clazz
        clazz = original_classname[0,1].capitalize + original_classname[1..-1]
        unless const_defined_in_module(module_namespace, clazz)
          new_class = module_namespace.const_set(clazz, Class.new(Databasedotcom::Sobject::Sobject))
          new_class.client = self
          new_class.materialize(original_classname)
          new_class
        else
          module_namespace.const_get(clazz)
        end
      end

      classes.length == 1 ? classes.first : classes
    end

    # Returns an Array of Hashes listing the properties for every type of _Sobject_ in the database. Raises SalesForceError if an error occurs.
    def describe_sobjects
      result = http_get("/services/data/v#{self.version}/sobjects")
      JSON.parse(result.body)["sobjects"]
    end

    # Returns a description of the Sobject specified by _class_name_. The description includes all fields and their properties for the Sobject.
    def describe_sobject(class_name)
      result = http_get("/services/data/v#{self.version}/sobjects/#{class_name}/describe")
      JSON.parse(result.body)
    end

    # Returns an instance of the Sobject specified by _class_or_classname_ (which can be either a String or a Class) populated with the values of the Force.com record specified by _record_id_.
    # If given a Class that is not defined, it will attempt to materialize the class on demand.
    #
    #    client.find(Account, "recordid") #=> #<Account @Id="recordid", ...>
    def find(class_or_classname, record_id)
      class_or_classname = find_or_materialize(class_or_classname)
      result = http_get("/services/data/v#{self.version}/sobjects/#{class_or_classname.sobject_name}/#{record_id}")
      response = JSON.parse(result.body)
      new_record = class_or_classname.new
      class_or_classname.description["fields"].each do |field|
        set_value(new_record, field["name"], response[key_from_label(field["label"])] || response[field["name"]], field["type"])
      end
      new_record
    end

    # Returns a Collection of Sobjects of the class specified in the _soql_expr_, which is a valid SOQL[http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_soql.htm] expression. The objects will only be populated with the values of attributes specified in the query.
    #
    #    client.query("SELECT Name FROM Account") #=> [#<Account @Id=nil, @Name="Foo", ...>, #<Account @Id=nil, @Name="Bar", ...> ...]
    def query(soql_expr)
      result = http_get("/services/data/v#{self.version}/query", :q => soql_expr)
      collection_from(result.body)
    end

    # Returns a Collection of Sobject instances form the results of the SOSL[http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_sosl.htm] search.
    #
    #    client.search("FIND {bar}") #=> [#<Account @Name="foobar", ...>, #<Account @Name="barfoo", ...> ...]
    def search(sosl_expr)
      result = http_get("/services/data/v#{self.version}/search", :q => sosl_expr)
      collection_from(result.body)
    end

    # Used by Collection objects. Returns a Collection of Sobjects from the specified URL path that represents the next page of paginated results.
    def next_page(path)
      result = http_get(path)
      collection_from(result.body)
    end

    # Used by Collection objects. Returns a Collection of Sobjects from the specified URL path that represents the previous page of paginated results.
    def previous_page(path)
      result = http_get(path)
      collection_from(result.body)
    end

    # Returns a new instance of _class_or_classname_ (which can be passed in as either a String or a Class) with the specified attributes.
    #
    #    client.create("Car", {"Color" => "Blue", "Year" => "2011"}) #=> #<Car @Id="recordid", @Color="Blue", @Year="2011">
    def create(class_or_classname, object_attrs)
      class_or_classname = find_or_materialize(class_or_classname)
      json_for_assignment = coerced_json(object_attrs, class_or_classname)
      result = http_post("/services/data/v#{self.version}/sobjects/#{class_or_classname.sobject_name}", json_for_assignment)
      new_object = class_or_classname.new
      JSON.parse(json_for_assignment).each do |property, value|
        set_value(new_object, property, value, class_or_classname.type_map[property][:type])
      end
      id = JSON.parse(result.body)["id"]
      set_value(new_object, "Id", id, "id")
      new_object
    end

    # Updates the attributes of the record of type _class_or_classname_ and specified by _record_id_ with the values of _new_attrs_ in the Force.com database. _new_attrs_ is a hash of attribute => value
    #
    #    client.update("Car", "rid", {"Color" => "Red"})
    def update(class_or_classname, record_id, new_attrs)
      class_or_classname = find_or_materialize(class_or_classname)
      json_for_update = coerced_json(new_attrs, class_or_classname)
      http_patch("/services/data/v#{self.version}/sobjects/#{class_or_classname.sobject_name}/#{record_id}", json_for_update)
    end

    # Attempts to find the record on Force.com of type _class_or_classname_ with attribute _field_ set as _value_. If found, it will update the record with the _attrs_ hash.
    # If not found, it will create a new record with _attrs_.
    #
    #    client.upsert(Car, "Color", "Blue", {"Year" => "2012"})
    def upsert(class_or_classname, field, value, attrs)
      clazz = find_or_materialize(class_or_classname)
      json_for_update = coerced_json(attrs, clazz)
      http_patch("/services/data/v#{self.version}/sobjects/#{clazz.sobject_name}/#{field}/#{value}", json_for_update)
    end

    # Deletes the record of type _class_or_classname_ with id of _record_id_. _class_or_classname_ can be a String or a Class.
    #
    #    client.delete(Car, "rid")
    def delete(class_or_classname, record_id)
      clazz = find_or_materialize(class_or_classname)
      http_delete("/services/data/v#{self.version}/sobjects/#{clazz.sobject_name}/#{record_id}")
    end

    # Returns a Collection of recently touched items. The Collection contains Sobject instances that are fully populated with their correct values.
    def recent
      result = http_get("/services/data/v#{self.version}/recent")
      collection_from(result.body)
    end

    # Returns an array of trending topic names.
    def trending_topics
      result = http_get("/services/data/v#{self.version}/chatter/topics/trending")
      result = JSON.parse(result.body)
      result["topics"].collect { |topic| topic["name"] }
    end

    # Performs an HTTP GET request to the specified path (relative to self.instance_url).  Query parameters are included from _parameters_.  The required
    # +Authorization+ header is automatically included, as are any additional headers specified in _headers_.  Returns the HTTPResult if it is of type
    # HTTPSuccess- raises SalesForceError otherwise.
    def http_get(path, parameters={}, headers={})
      with_encoded_path_and_checked_response(path, parameters) do |encoded_path|
        https_request.get(encoded_path, {"Authorization" => "OAuth #{self.oauth_token}"}.merge(headers))
      end
    end


    # Performs an HTTP DELETE request to the specified path (relative to self.instance_url).  Query parameters are included from _parameters_.  The required
    # +Authorization+ header is automatically included, as are any additional headers specified in _headers_.  Returns the HTTPResult if it is of type
    # HTTPSuccess- raises SalesForceError otherwise.
    def http_delete(path, parameters={}, headers={})
      with_encoded_path_and_checked_response(path, parameters, {:expected_result_class => Net::HTTPNoContent}) do |encoded_path|
        https_request.delete(encoded_path, {"Authorization" => "OAuth #{self.oauth_token}"}.merge(headers))
      end
    end

    # Performs an HTTP POST request to the specified path (relative to self.instance_url).  The body of the request is taken from _data_.
    # Query parameters are included from _parameters_.  The required +Authorization+ header is automatically included, as are any additional
    # headers specified in _headers_.  Returns the HTTPResult if it is of type HTTPSuccess- raises SalesForceError otherwise.
    def http_post(path, data=nil, parameters={}, headers={})
      with_encoded_path_and_checked_response(path, parameters, {:data => data}) do |encoded_path|
        https_request.post(encoded_path, data, {"Content-Type" => data ? "application/json" : "text/plain", "Authorization" => "OAuth #{self.oauth_token}"}.merge(headers))
      end
    end

    # Performs an HTTP PATCH request to the specified path (relative to self.instance_url).  The body of the request is taken from _data_.
    # Query parameters are included from _parameters_.  The required +Authorization+ header is automatically included, as are any additional
    # headers specified in _headers_.  Returns the HTTPResult if it is of type HTTPSuccess- raises SalesForceError otherwise.
    def http_patch(path, data=nil, parameters={}, headers={})
      with_encoded_path_and_checked_response(path, parameters, {:data => data}) do |encoded_path|
        https_request.send_request("PATCH", encoded_path, data, {"Content-Type" => data ? "application/json" : "text/plain", "Authorization" => "OAuth #{self.oauth_token}"}.merge(headers))
      end
    end

    # Performs an HTTP POST request to the specified path (relative to self.instance_url), using Content-Type multiplart/form-data.
    # The parts of the body of the request are taken from parts_. Query parameters are included from _parameters_.  The required
    # +Authorization+ header is automatically included, as are any additional headers specified in _headers_.
    # Returns the HTTPResult if it is of type HTTPSuccess- raises SalesForceError otherwise.
    def http_multipart_post(path, parts, parameters={}, headers={})
      with_encoded_path_and_checked_response(path, parameters) do |encoded_path|
        https_request.request(Net::HTTP::Post::Multipart.new(encoded_path, parts, {"Authorization" => "OAuth #{self.oauth_token}"}.merge(headers)))
      end
    end

    private

    def with_encoded_path_and_checked_response(path, parameters, options = {})
      ensure_expected_response(options[:expected_result_class]) do
        with_logging(encode_path_with_params(path, parameters), options) do |encoded_path|
          yield(encoded_path)
        end
      end
    end

    def with_logging(encoded_path, options)
      log_request(encoded_path, options)
      response = yield encoded_path
      log_response(response)
      response
    end

    def ensure_expected_response(expected_result_class)
      response = yield

      unless response.is_a?(expected_result_class || Net::HTTPSuccess)
        if response.is_a?(Net::HTTPUnauthorized)
          if self.refresh_token
            response = with_encoded_path_and_checked_response("/services/oauth2/token", { :grant_type => "refresh_token", :refresh_token => self.refresh_token, :client_id => self.client_id, :client_secret => self.client_secret}, :host => self.host) do |encoded_path|
              response = https_request(self.host).post(encoded_path, nil)
              if response.is_a?(Net::HTTPOK)
                parse_auth_response(response.body)
              end
              response
            end
          elsif self.username && self.password
            response = with_encoded_path_and_checked_response("/services/oauth2/token", { :grant_type => "password", :username => self.username, :password => self.password, :client_id => self.client_id, :client_secret => self.client_secret}, :host => self.host) do |encoded_path|
              response = https_request(self.host).post(encoded_path, nil)
              if response.is_a?(Net::HTTPOK)
                parse_auth_response(response.body)
              end
              response
            end
          end

          if response.is_a?(Net::HTTPSuccess)
            response = yield
          end
        end

        raise SalesForceError.new(response) unless response.is_a?(expected_result_class ||  Net::HTTPSuccess)
      end

      response
    end

    def https_request(host=nil)
      Net::HTTP.new(host || URI.parse(self.instance_url).host, 443).tap do |http| 
        http.use_ssl = true 
        http.ca_file = self.ca_file if self.ca_file
        http.verify_mode = self.verify_mode if self.verify_mode
      end
    end

    def encode_path_with_params(path, parameters={})
      [URI.escape(path), encode_parameters(parameters)].reject{|el| el.empty?}.join('?')
    end

    def encode_parameters(parameters={})
      (parameters || {}).collect { |k, v| "#{uri_escape(k)}=#{uri_escape(v)}" }.join('&')
    end

    def log_request(path, options={})
      base_url = options[:host] ? "https://#{options[:host]}" : self.instance_url
      puts "***** REQUEST: #{path.include?(':') ? path : URI.join(base_url, path)}#{options[:data] ? " => #{options[:data]}" : ''}" if self.debugging
    end

    def uri_escape(str)
      URI.escape(str.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def log_response(result)
      puts "***** RESPONSE: #{result.class.name} -> #{result.body}" if self.debugging
    end

    def find_or_materialize(class_or_classname)
      if class_or_classname.is_a?(Class)
        clazz = class_or_classname
      else
        match = class_or_classname.match(/(?:(.+)::)?(\w+)$/)
        preceding_namespace = match[1]
        classname = match[2]
        raise ArgumentError if preceding_namespace && preceding_namespace != module_namespace.name
        clazz = module_namespace.const_get(classname.to_sym) rescue nil
        clazz ||= self.materialize(classname)
      end
      clazz
    end

    def module_namespace
      _module = self.sobject_module
      _module = _module.constantize if _module.is_a? String
      _module || Object
    end

    def collection_from(response)
      response = JSON.parse(response)
      collection_from_hash( response )
    end

    # Converts a Hash of object data into a concrete SObject
    def record_from_hash(data)
      attributes = data.delete('attributes')
      new_record = find_or_materialize(attributes["type"]).new
      data.each do |name, value|
        field = new_record.description['fields'].find do |field|
          key_from_label(field["label"]) == name || field["name"] == name || field["relationshipName"] == name
        end

        # Field not found
        if field == nil
          break
        end

        # If reference/lookup field data was fetched, recursively build the child record and apply
        if value.is_a?(Hash) and field['type'] == 'reference' and field["relationshipName"]
          relation = record_from_hash( value )
          set_value( new_record, field["relationshipName"], relation, 'reference' )

        # Apply the raw value for all other field types
        else
          set_value(new_record, field["name"], value, field["type"]) if field
        end
      end
      new_record
    end

    def collection_from_hash(data)
      array_response = data.is_a?(Array)
      if array_response
        records = data.collect { |rec| self.find(rec["attributes"]["type"], rec["Id"]) }
      else
        records = data["records"].collect do |record|
          record_from_hash( record )
        end
      end

      Databasedotcom::Collection.new(self, array_response ? records.length : data["totalSize"], array_response ? nil : data["nextRecordsUrl"]).concat(records)
    end

    def set_value(record, attr, value, attr_type)
      value_to_set = value

      case attr_type
        when "datetime"
          value_to_set = DateTime.parse(value) rescue nil

        when "date"
          value_to_set = Date.parse(value) rescue nil

        when "multipicklist"
          value_to_set = value.split(";") rescue []
      end

      record.send("#{attr}=", value_to_set)
    end

    def coerced_json(attrs, clazz)
      if attrs.is_a?(Hash)
        coerced_attrs = {}
        attrs.keys.each do |key|
          case clazz.field_type(key)
            when "multipicklist"
              coerced_attrs[key] = (attrs[key] || []).join(';')
            when "datetime"
              coerced_attrs[key] = attrs[key] ? attrs[key].strftime(RUBY_VERSION.match(/^1.8/) ? "%Y-%m-%dT%H:%M:%S.000%z" : "%Y-%m-%dT%H:%M:%S.%L%z") : nil
            else
              coerced_attrs[key] = attrs[key]
          end
        end
        coerced_attrs.to_json
      else
        attrs
      end
    end

    def key_from_label(label)
      label.gsub(' ', '_')
    end

    def user_and_pass?(options)
      (self.username && self.password) || (options && options[:username] && options[:password])
    end

    def parse_user_id_and_org_id_from_identity_url(identity_url)
      m = identity_url.match(/\/id\/([^\/]+)\/([^\/]+)$/)
      @org_id = m[1] rescue nil
      @user_id = m[2] rescue nil
    end

    def parse_auth_response(body)
      json = JSON.parse(body)
      parse_user_id_and_org_id_from_identity_url(json["id"])
      self.instance_url = json["instance_url"]
      self.oauth_token = json["access_token"]
    end

    def query_org_id
      query("select id from Organization")[0]["Id"]
    end

    def const_defined_in_module(mod, const)
      mod.method(:const_defined?).arity == 1 ? mod.const_defined?(const) : mod.const_defined?(const, false)
    end
  end
end
