require 'databasedotcom/chatter/record'
require 'databasedotcom/chatter/photo_methods'

module Databasedotcom
  module Chatter
    # A group of Users
    class Group < Record
      include PhotoMethods

      # Returns a Collection of GroupMembership instances for the Group identified by _group_id_.
      def self.members(client, group_id)
        url = "/services/data/v#{client.version}/chatter/groups/#{group_id}/members"
        result = client.http_get(url)
        response = JSON.parse(result.body)
        collection = Databasedotcom::Collection.new(client, response["totalMemberCount"], response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        response["members"].each do |member|
          collection << GroupMembership.new(client, member)
        end
        collection
      end

      # Join the group identified by _group_id_ as the user identified by _user_id_.
      def self.join(client, group_id, user_id="me")
        url = "/services/data/v#{client.version}/chatter/groups/#{group_id}/members"
        response = client.http_post(url, nil, :userId => user_id)
        GroupMembership.new(client, response.body)
      end

      # Get a Collection of GroupMembership objects for this Group. Always makes a call to the server.
      def members!
        self.class.members(self.client, self.id)
      end

      # Get a Collection of GroupMembership objects for this Group. Returns cached data if it has been called before.
      def members
        @members ||= members!
      end

      # Join this Group as the user identified by _user_id_.
      def join(user_id="me")
        self.class.join(self.client, self.id, user_id)
      end
    end
  end
end