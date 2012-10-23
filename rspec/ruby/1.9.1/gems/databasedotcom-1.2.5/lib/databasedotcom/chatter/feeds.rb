require 'databasedotcom/chatter/feed'

Databasedotcom::Chatter::FEED_TYPES.each do |feed_type|
  Databasedotcom::Chatter.const_set("#{feed_type}Feed", Class.new(Databasedotcom::Chatter::Feed))
end
