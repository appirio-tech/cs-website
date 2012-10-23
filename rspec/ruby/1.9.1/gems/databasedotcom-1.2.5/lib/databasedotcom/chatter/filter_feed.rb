module Databasedotcom
  module Chatter
    # Filter feeds contain items pertaining to both a user and another specified resource.
    class FilterFeed < Feed

      # Lists all FilterFeeds for the user with id _user_id_.
      def self.feeds(client, user_id="me")
        url = "/services/data/v#{client.version}/chatter/feeds/filter/#{user_id}"
        result = client.http_get(url)
        JSON.parse(result.body)
      end
    end
  end
end