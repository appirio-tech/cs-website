require 'databasedotcom/chatter/record'

module Databasedotcom
  module Chatter

    # An item in a Feed.
    class FeedItem < Record

      # Returns a Collection of comments that were posted on this FeedItem instance.
      def comments
        collection = Databasedotcom::Collection.new(self.client, self.raw_hash["comments"]["total"], self.raw_hash["comments"]["nextPageUrl"], nil, self.raw_hash["comments"]["currentPageUrl"])
        collection.concat(self.raw_hash["comments"]["comments"])
      end

      # Returns a Collection of likes for this FeedItem instance.
      def likes
        collection = Databasedotcom::Collection.new(self.client, self.raw_hash["likes"]["total"], self.raw_hash["likes"]["nextPageUrl"], self.raw_hash["likes"]["previousPageUrl"], self.raw_hash["likes"]["currentPageUrl"])
        collection.concat(self.raw_hash["likes"]["likes"])
      end

      # Like this FeedItem.
      def like
        result = self.client.http_post("/services/data/v#{self.client.version}/chatter/feed-items/#{self.id}/likes")
        Like.new(self.client, result.body)
      end

      # Post a Comment on this FeedItem with content _text_.
      def comment(text)
        result = self.client.http_post("/services/data/v#{self.client.version}/chatter/feed-items/#{self.id}/comments", nil, :text => text)
        Comment.new(self.client, result.body)
      end

      protected

      def self.collection_from_response(response)
        response["items"]
      end
    end
  end
end