require 'databasedotcom/chatter/record'

module Databasedotcom
  module Chatter
    # A thread of private messages. When calling +Conversation.find+ or +Conversation.all+, you must pass +:user_id => <my_user_id>+ in the _parameters_
    #
    #    Conversation.all(@client, :user_id => "me")
    #    Conversation.find(@client, "conversationId", :user_id => "f80ad89f9d98d89dfd89")
    class Conversation < Record

      # Creates a new Conversation and sets its +id+ and +url+ to values obtained from the server response.
      def initialize(client, response)
        super
        @id ||= @raw_hash["conversationId"]
        @url ||= @raw_hash["conversationUrl"]
      end

      # Find the Conversation identified by _cid_ and archive it. Returns the updated Conversation.
      #
      #    Conversation.archive(@client, "fakeid")
      def self.archive(client, cid)
        url = "/services/data/v#{client.version}/chatter/users/me/conversations/#{cid}"
        response = client.http_patch(url, nil, :archived => "true")
        Conversation.new(client, response.body)
      end

      # Find the Conversation identified by _cid_ and unarchive it. Returns the updated Conversation.
      #
      #    Conversation.unarchive(@client, "fakeid")
      def self.unarchive(client, cid)
        url = "/services/data/v#{client.version}/chatter/users/me/conversations/#{cid}"
        response = client.http_patch(url, nil, :archived => "false")
        Conversation.new(client, response.body)
      end

      # Find the Conversation identified by _cid_ and mark it as read. Returns the updated Conversation.
      #
      #    Conversation.mark_read(@client, "fakeid")
      def self.mark_read(client, cid)
        url = "/services/data/v#{client.version}/chatter/users/me/conversations/#{cid}"
        response = client.http_patch(url, nil, :read => "true")
        Conversation.new(client, response.body)
      end

      # Find the Conversation identified by _cid_ and mark it as unread. Returns the updated Conversation.
      #
      #    Conversation.mark_unread(@client, "fakeid")
      def self.mark_unread(client, cid)
        url = "/services/data/v#{client.version}/chatter/users/me/conversations/#{cid}"
        response = client.http_patch(url, nil, :read => "false")
        Conversation.new(client, response.body)
      end

      # Gets all messages for the Conversation specified by _cid_ and the User specified by _uid_. Returns a Collection of Message objects.
      def self.messages(client, uid, cid)
        conversation = self.find(client, cid, :user_id => uid)
        collection = Databasedotcom::Collection.new(client, nil, conversation.raw_hash["messages"]["nextPageUrl"], conversation.raw_hash["messages"]["previousPageUrl"], conversation.raw_hash["messages"]["currentPageUrl"])
        conversation.raw_hash["messages"]["messages"].each do |item|
          collection << Message.new(client, item)
        end
        collection
      end

      # Archive this Conversation.
      def archive
        self.class.archive(self.client, self.id)
      end

      # Unarchive this Conversation.
      def unarchive
        self.class.unarchive(self.client, self.id)
      end

      # Mark this Conversation as read.
      def mark_read
        self.class.mark_read(self.client, self.id)
      end

      # Mark this Conversation as unread.
      def mark_unread
        self.class.mark_unread(self.client, self.id)
      end

      # Return a Collection of messages from this Conversation.
      def messages
        collection = Databasedotcom::Collection.new(client, nil, self.raw_hash["messages"]["nextPageUrl"], self.raw_hash["messages"]["previousPageUrl"], self.raw_hash["messages"]["currentPageUrl"])
        self.raw_hash["messages"]["messages"].each do |item|
          collection << Message.new(client, item)
        end
        collection
      end

      protected

      def self.search_parameter_name
        :Q
      end
    end
  end
end