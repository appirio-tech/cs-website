require 'cs_api_account'
require 'cs_api_member'

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

desc "Pick sweepstakes winners -- bundle exec rake pick_sweepstakes_winners[1907]"
task :pick_sweepstakes_winners, :challenge_id do |t, args|
	participants = HTTParty.get("https://api.cloudspokes.com/v1/challenges/#{args.challenge_id}/participants")['response']
	puts "#{participants.count} participants"
	puts "First place: #{participants[rand(participants.count)]['member__r']['name']}"
	puts "Second place: #{participants[rand(participants.count)]['member__r']['name']}"
end

desc "Reads members from pg and creates them in sfdc"
task :import_members, :partner_name, :limit, :randomize, :needs => :environment do |t, args|

	access_token = SfdcConnection.admin_dbdc_client.oauth_token

	ImportMember.where("sfdc_username is null").limit(args.limit).each do |m|

		# create the membername from the first part of the email
		membername = m.email.slice(0,m.email.index('@'))
		plain_text_password = (0...6).map{65.+(rand(26)).chr}.join+rand(99).to_s
		if args.randomize
			membername << rand(99).to_s
			puts "[INFO]Randomizing membername to overcome dupes. New membername: #{membername}"
		end

		# create the member in sfdc
		results = CsApi::Account.create(access_token, 
			{:username => membername, :password => plain_text_password, :email => m.email}).symbolize_keys!

		if results[:success].eql?('true')

			puts "[INFO]Creating new SFDC member for #{membername}: #{results}"

			# update the import member with the sfdc username and temp password
			m.sfdc_username = results[:sfdc_username]
			m.membername = membername
			m.temp_password = Encryptinator.encrypt_string(plain_text_password)
			m.save

			# update with some data
			update_results = CsApi::Member.update(access_token, membername, {'school__c' => m.school, 
				'campaign_medium__c' => m.campaign_medium, 'campaign_name__c' => m.campaign_name, 
				'campaign_source__c' => m.campaign_source, 'first_name__c' => m.first_name, 
				'last_name__c' => m.last_name}).symbolize_keys!
			
			puts "[FATAL]Updating member #{membername}: #{update_results}" if update_results[:success].eql?('false')

		  # send the 'welcome' email
		  Resque.enqueue(WelcomeEmailFromImportSender, membername, m.email, plain_text_password, "#{args.partner_name} Welcomes you to CloudSpokes", args.partner_name) unless ENV['MAILER_ENABLED'].eql?('false')
		  # add the user to badgeville
		  Resque.enqueue(NewBadgeVilleUser, access_token, membername, results[:sfdc_username]) unless ENV['BADGEVILLE_ENABLED'].eql?('false')		

		  sleep(5)

		# coud not create member in salesforce
		else
			m.error_message = results[:message]
			m.save
			puts "[FATAL]Could not create sfdc user for #{membername}: #{results[:message]}"
		end

	end	

	puts "[INFO]Member import finished!"

end