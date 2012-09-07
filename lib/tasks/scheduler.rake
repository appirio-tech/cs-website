desc "This task is called by the Heroku scheduler add-on to cache home page stats"
task :cache_platform_stats => :environment do
    puts "Calling SFDC to cache platform stats...."
    results = Services.submit_platform_stats_job(current_access_token)
    puts results['message']
end