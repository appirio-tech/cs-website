atom_feed :language => 'en-US' do |feed|
  feed.title @feed_title
  feed.updated DateTime.now

  @feed_items.each do |item|
    feed.entry(item, :url => "http://#{request.env['HTTP_HOST']}/account/judging_queue") do |entry|
      entry.url "http://#{request.env['HTTP_HOST']}/account/judging_queue"
      entry.title item.title
      entry.content ("#{category_display_new_api(item.categories)}<br>Challenge ends: #{Time.parse(item.end_date).strftime("%b. %d %Y at %I:%M %p")}<br><br>Scorecards due: #{Date.parse(item.due_date).strftime('%m/%d/%Y')}"), :type => 'html'
      entry.updated(Time.parse(item.end_date).strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.author do |author|
        author.name 'CloudSpokes Team'
      end
    end
  end
end