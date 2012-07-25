class AdminController < ApplicationController
  before_filter :authenticate
  
  def index
  end

  def create_badgeville_users
    connection = SfdcConnection.admin_dbdc_client
    @users = connection.query("select id, name from member__c where badgeville_id__c = '' and id not in ('a0IU0000001Ld8L') order by createddate desc limit 1000")
    @users.each do |u|
      begin  
        email = u.Name+'@m.cloudspokes.com'
        username = u.Name
        puts "==== PROCESSING #{username}"
        results = Badgeville.get_user_by_email(email)
        if results.has_key?('error') 
          puts "**** Creating a user for #{username} via resque ****"
          Resque.enqueue(NewBadgeVilleUser, current_access_token, username, email) 
        else
          puts "==== #{username} already exists: #{results}"
          # check for a player and create if it does not exist
          Badgeville.create_player(username, email) if Badgeville.get_player_by_email(email).has_key?('error')
          connection.materialize("Member__c")
          member = Member__c.find_by_name(username)
          member.update_attributes('Badgeville_Id__c' => results['data']['_id'])
          member.save
          puts "==== #{username} updated in salesforce"
        end
      rescue Exception => exc
        puts "==== Couldn't create user: #{exc.message}" 
      end   
    end
    render :text => 'Done!'
  end
  
  def blogfodder
    @challenge = Challenges.find_by_id(current_access_token, params[:id])[0]
    @winners = Challenges.winners(current_access_token, params[:id])
    @all_submissions = Challenges.all_submissions(current_access_token, params[:id])
  end
  
  def refresh_token
    
    logger.info "[AdminController]==== refreshing the settting table with a new access token for #{ENV['SFDC_USERNAME']}"
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    access_token = client.authenticate :username => ENV['SFDC_USERNAME'], :password => ENV['SFDC_PASSWORD']  
    # delete the current record
    p Settings.delete(Settings.first)
    # save the new token
    s = Settings.new
    s.access_token = access_token
    s.save
    render :inline => "Token refreshed and written to pg - #{access_token}"
  end
  
  def delete_all_users
    User.delete_all
    render :inline => "All users deleted from PG and logged off from the site"
  end
  
  def display_settings
    @results = Settings.all
  end  
  
  def send_mail
    Resque.enqueue(WelcomeEmailSender, current_access_token, 'jeffdonthemic')
    render :inline => "Mail sent"
  end
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['MAILER_USERNAME'] && password == ENV['MAILER_PASSWORD']
    end
  end

end
