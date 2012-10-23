require 'json'

module Databasedotcom
  module Chatter
    # Superclasses all Chatter resources except feeds. Some methods may not be supported by the Force.com API for certain subclasses.
    class Record
      attr_reader :raw_hash, :name, :id, :url, :type, :client

      # Create a new record from the returned JSON response of an API request. Sets the client, name, id, url, and type attributes. Saves the raw response as +raw_hash+.
      def initialize(client, response)
        @client = client
        @raw_hash = response.is_a?(Hash) ? response : JSON.parse(response)
        @name = @raw_hash["name"]
        @id = @raw_hash["id"]
        @url = @raw_hash["url"]
        @type = @raw_hash["type"]
      end

      # Find a single Record or a Collection of records by id. _resource_id_ can be a single id or a list of ids.
      def self.find(client, resource_id, parameters={})
        if resource_id.is_a?(Array)
          resource_ids = resource_id.join(',')
          url = "/services/data/v#{client.version}/chatter/#{self.resource_name}/batch/#{resource_ids}"
          response = JSON.parse(client.http_get(url, parameters).body)
          good_results = response["results"].select { |r| r["statusCode"] == 200 }
          collection = Databasedotcom::Collection.new(client, good_results.length)
          good_results.each do |result|
            collection << self.new(client, result["result"])
          end
          collection
        else
          path_components = ["/services/data/v#{client.version}/chatter"]
          if parameters.has_key?(:user_id)
            path_components << "users/#{parameters[:user_id]}"
            parameters.delete(:user_id)
          end
          path_components << "#{self.resource_name}/#{resource_id}"
          url = path_components.join('/')
          response = JSON.parse(client.http_get(url, parameters).body)
          self.new(client, response)
        end
      end

      # Return a Collection of records that match the _query_.
      def self.search(client, query, parameters={})
        self.all(client, parameters.merge(self.search_parameter_name => query))
      end

      # Return a Collection of all records.
      def self.all(client, parameters={})
        path_components = ["/services/data/v#{client.version}/chatter"]
        if parameters.has_key?(:user_id)
          path_components << "users/#{parameters[:user_id]}"
          parameters.delete(:user_id)
        end
        path_components << self.resource_name
        url = path_components.join('/')
        result = client.http_get(url, parameters)
        response = JSON.parse(result.body)
        collection = Databasedotcom::Collection.new(client, self.total_size_of_collection(response), response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        self.collection_from_response(response).each do |resource|
          collection << self.new(client, resource)
        end
        collection
      end

      # Delete the Record identified by _resource_id_.
      def self.delete(client, resource_id, parameters={})
        path_components = ["/services/data/v#{client.version}/chatter"]
        if parameters.has_key?(:user_id)
          path_components << "users/#{parameters[:user_id]}"
          parameters.delete(:user_id)
        end
        path_components << self.resource_name
        path_components << resource_id
        path = path_components.join('/')
        client.http_delete(path, parameters)
      end

      # A Hash representation of the User that created this Record.
      def user
        self.raw_hash["user"]
      end

      # A Hash representation of the entity that is the parent of this Record.
      def parent
        self.raw_hash["parent"]
      end

      # Delete this record.
      def delete(parameters={})
        self.class.delete(self.client, self.id, parameters)
      end

      # Reload this record.
      def reload
        self.class.find(self.client, self.id)
      end

      # The REST resource name of this Record.
      #
      #    GroupMembership.resource_name  #=>  group-memberships
      def self.resource_name
        (self.name.split('::').last).resourcerize + "s"
      end

      protected

      def self.total_size_of_collection(response)
        response["total"] || response["totalMemberCount"]
      end

      def self.collection_from_response(response)
        response[self.resource_name]
      end

      def self.search_parameter_name
        :q
      end
    end
  end
end