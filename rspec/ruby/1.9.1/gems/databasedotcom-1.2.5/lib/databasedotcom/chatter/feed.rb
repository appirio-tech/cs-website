require 'json'

module Databasedotcom
  module Chatter
    # Parent class of all feeds and inherits from Collection. This class is not intended to be instantiated. Methods should be called on subclasses, which are all are dynamically defined (except for FilterFeed). Defined feeds are *NewsFeed*, *UserProfileFeed*, *RecordFeed*, *ToFeed*, *PeopleFeed*, *GroupsFeed*, *FilesFeed*, *CompanyFeed*, and *FilterFeed*.
    class Feed < Collection

      # Returns an enumerable Feed of FeedItem objects that make up the feed with the specified _id_. Should not be called as a class method on Feed, but as a method on subclasses.
      #
      #    NewsFeed.find(@client)                   #=>   [#<FeedItem ...>, #<FeedItem ...>, ...]
      #    PeopleFeed.find(@client, "userid")       #=>   [#<FeedItem ...>, #<FeedItem ...>, ...]
      #    FilterFeed.find(@client, "me", "000")    #=>   [#<FeedItem ...>, #<FeedItem ...>, ...]
      #
      # _id_prefix_ is only applicable for FilterFeed.
      def self.find(client, id="me", id_prefix=nil)
        path_components = %w(services data)
        path_components << "v#{client.version}"
        path_components.concat(%w(chatter feeds))
        path_components << feed_type
        path_components << id unless feed_type == "company"
        path_components << id_prefix
        path_components << "feed-items"
        path = "/" + path_components.compact.join('/')
        result = client.http_get(path)
        response = JSON.parse(result.body)
        collection = self.new(client, nil, response["nextPageUrl"], response["previousPageUrl"], response["currentPageUrl"])
        response["items"].each do |item|
          collection << FeedItem.new(client, item)
        end
        collection
      end

      # Posts a FeedItem to a Feed specified by _user_id_. Should not be called as a class method on Feed, but as a method on subclasses.
      #
      #    UserProfileFeed.post(@client, "me", :text => "This is a status update about Salesforce.", :url => "http://www.salesforce.com")
      #
      # Returns the newly created FeedItem.
      def self.post(client, user_id, parameters)
        url = "/services/data/v#{client.version}/chatter/feeds/#{feed_type}/#{user_id}/feed-items"
        response = client.http_post(url, nil, parameters)
        Databasedotcom::Chatter::FeedItem.new(client, response.body)
      end

      # Posts a file to a Feed specified by _user_id_. Should not be called as a class method on Feed, but as a method on subclasses.
      #
      #    UserProfileFeed.post_file(@client, "me", File.open("MyFile"), "text/plain", "MyFile", :desc => "This is an uploaded text file.")
      #
      # Returns the newly created FeedItem.
      def self.post_file(client, user_id, io, file_type, file_name, parameters={})
        url = "/services/data/v#{client.version}/chatter/feeds/#{feed_type}/#{user_id}/feed-items"
        response = client.http_multipart_post(url, {"feedItemFileUpload" => UploadIO.new(io, file_type, file_name), "fileName" => file_name}, parameters)
        Databasedotcom::Chatter::FeedItem.new(client, response.body)
      end

      private

      def self.feed_type
        self.name.match(/.+::(.+)Feed$/)[1].resourcerize
      end
    end

    FEED_TYPES = %w(News UserProfile Record To People Groups Files Company)
  end
end