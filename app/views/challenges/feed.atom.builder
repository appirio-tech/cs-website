atom_feed :language => 'en-US' do |feed|
  feed.title @feed_title
  feed.updated DateTime.now

  @feed_items.each do |item|
    feed.entry(item) do |entry|
      entry.url "http://#{request.env['HTTP_HOST']}/challenges/#{item.id}"
      entry.title item.title
      entry.content item.content, :type => 'html'
      entry.updated(DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.author do |author|
        author.name 'CloudSpokes Team'
      end
    end
  end
end