desc "Returns a salesforce.com access token for the current environment"
task :get_access_token => :environment do
	# log in for an access token
	config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
	client = Databasedotcom::Client.new(config)
	access_token = client.authenticate :username => ENV['SFDC_USERNAME'], :password => ENV['SFDC_PASSWORD']  
	puts "Access token for #{ENV['DATABASEDOTCOM_HOST']}: #{access_token}"
end

desc "Send an 'invite' email to jeffdonthemic"
task :send_invite => :environment do
	Resque.enqueue(InviteEmailSender, 'jeffdonthemic', 'jeff@appirio.com')
	puts "Email sent!!"
end