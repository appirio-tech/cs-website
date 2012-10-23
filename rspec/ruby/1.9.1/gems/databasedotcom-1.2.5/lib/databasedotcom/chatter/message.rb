require 'databasedotcom/chatter/record'

module Databasedotcom
  module Chatter
    # A private message between two or more Users
    class Message < Record

      # Send a private message with the content _text_ to each user in the _recipients_ list.
      def self.send_message(client, recipients, text)
        url = "/services/data/v#{client.version}/chatter/users/me/messages"
        recipients = recipients.is_a?(Array) ? recipients : [recipients]
        response = client.http_post(url, nil, :text => text, :recipients => recipients.join(','))
        Message.new(client, response.body)
      end

      # Send a reply to the message identified by _in_reply_to_message_id_ with content _text_.
      def self.reply(client, in_reply_to_message_id, text)
        url = "/services/data/v#{client.version}/chatter/users/me/messages"
        response = client.http_post(url, nil, :text => text, :inReplyTo => in_reply_to_message_id)
        Message.new(client, response.body)
      end

      # Send a reply to this Message with content _text_.
      def reply(text)
        self.class.reply(self.client, self.id, text)
      end
    end
  end
end