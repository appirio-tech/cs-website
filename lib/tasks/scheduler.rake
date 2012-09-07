desc "This task is called by the Heroku scheduler add-on to cache home page stats"
task :cache_platform_stats => :environment do
    puts "Calling SFDC to cache platform stats...."

    # log in for an access token
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    access_token = client.authenticate :username => ENV['SFDC_USERNAME'], :password => ENV['SFDC_PASSWORD']  

    results = Services.submit_platform_stats_job(access_token)
    puts "Kicked off Apex Job with ID #{results['message']}"
end