require 'databasedotcom/chatter/record'
require 'databasedotcom/chatter/photo_methods'

module Databasedotcom
  module Chatter
    # Defines a User in your org.
    class User < Record
      include PhotoMethods

      # Returns a Collection of Subscription objects that represents all followers of the User identified by _subject_id_.
      def self.followers(client, subject_id="me")
        url = "/services/data/v#{client.version}/chatter/users/#{subject_id}/followers"
        result = client.http_get(url)
        response = JSON.parse(result.body)
        collection = Databasedotcom::Collection.new(client, response["total"], response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        response["followers"].each do |subscription|
          collection << Subscription.new(client, subscription)
        end
        collection
      end

      # Returns a Collection of Subscription objects that represent all entities that the User identified by _subject_id_ is following.
      def self.following(client, subject_id="me")
        url = "/services/data/v#{client.version}/chatter/users/#{subject_id}/following"
        result = client.http_get(url)
        response = JSON.parse(result.body)
        collection = Databasedotcom::Collection.new(client, response["total"], response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        response["following"].each do |subscription|
          collection << Subscription.new(client, subscription)
        end
        collection
      end

      # Returns a Collection of Group objects that represent all the groups that the User identified by _subject_id_ is a part of.
      def self.groups(client, subject_id="me")
        url = "/services/data/v#{client.version}/chatter/users/#{subject_id}/groups"
        result = client.http_get(url)
        response = JSON.parse(result.body)
        collection = Databasedotcom::Collection.new(client, response["total"], response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        response["groups"].each do |group|
          collection << Group.new(client, group)
        end
        collection
      end

      # Returns the current status of the User identified by _subject_id_.
      def self.status(client, subject_id="me")
        url = "/services/data/v#{client.version}/chatter/users/#{subject_id}/status"
        result = client.http_get(url)
        JSON.parse(result.body)
      end

      # Posts a status update as the User identified by _subject_id_ with content _text_.
      def self.post_status(client, subject_id, text)
        url = "/services/data/v#{client.version}/chatter/users/#{subject_id}/status"
        result = client.http_post(url, nil, :text => text)
        JSON.parse(result.body)
      end

      # Deletes the status of User identified by _subject_id_.
      def self.delete_status(client, subject_id="me")
        client.http_delete "/services/data/v#{client.version}/chatter/users/#{subject_id}/status"
      end

      # Creates and returns a new Subscription object that represents the User identified by _subject_id_ following the resource identified by _resource_id_.
      def self.follow(client, subject_id, resource_id)
        response = client.http_post("/services/data/v#{client.version}/chatter/users/#{subject_id}/following", nil, :subjectId => resource_id)
        Subscription.new(client, response.body)
      end

      # Returns a Collection of conversations that belong to the User identified by _subject_id_.
      def self.conversations(client, subject_id)
        Conversation.all(client, :user_id => subject_id)
      end

      # Returns a Collection of private messages that belong to the User identified by _subject_id_.
      def self.messages(client, subject_id)
        Message.all(client, :user_id => subject_id)
      end

      # Get a Collection of Subscription objects for this User. Always makes a call to the server.
      def followers!
        self.class.followers(self.client, self.id)
      end

      # Get a Collection of Subscription objects for this User. Returns cached data if it has been called before.
      def followers
        @followers ||= followers!
      end

      # Get a Collection of Subscription objects that represents all resources that this User is following. Always makes a call to the server.
      def following!
        self.class.following(self.client, self.id)
      end

      # Get a Collection of Subscription objects that represents all resources that this User is following. Returns cached data if it has been called before.
      def following
        @following ||= following!
      end

      # Returns this current status of this User.
      def status
        self.raw_hash["currentStatus"]
      end

      # Posts a new status with content _text_ for this User.
      def post_status(text)
        self.class.post_status(self.client, self.id, text)
      end

      # Deletes the current status of this User. Returns the deleted status.
      def delete_status
        self.class.delete_status(self.client, self.id)
        status
      end

      # Get a Collection of Group objects that represents all groups that this User is in. Always makes a call to the server.
      def groups!
        self.class.groups(self.client, self.id)
      end

      # Get a Collection of Group objects that represents all groups that this User is in. Returns cached data if it has been called before.
      def groups
        @groups ||= groups!
      end

      # Creates a new Subscription that represents this User following the resource with id _record_id_.
      def follow(record_id)
        self.class.follow(self.client, self.id, record_id)
      end

      # Get a Collection of Conversation objects that represents the conversations for this User. Always makes a call to the server.
      def conversations!
        self.class.conversations(self.client, self.id)
      end

      # Get a Collection of Conversation objects that represents the conversations for this User. Returns cached data if it has been called before.
      def conversations
        @conversations ||= conversations!
      end

      # Get a Collection of Message objects that represents the messages for this User. Always makes a call to the server.
      def messages!
        self.class.messages(self.client, self.id)
      end

      # Get a Collection of Message objects that represents the messages for this User. Returns cached data if it has been called before.
      def messages
        @messages ||= messages!
      end
    end
  end
end