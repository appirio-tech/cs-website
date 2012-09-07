require 'services'

class AdminController < ApplicationController

  before_filter :authenticate

  # makes sure the badgeville id in sfdc and in badgeville are the same
  def update_badgeville_player_ids
    connection = SfdcConnection.admin_dbdc_client
    (0..9).each do |l|
      puts "==== doing loop #{l}"
      members = connection.query("select id, name, badgeville_id__c from member__c where Badgeville_Id_Checked__c = false and id not in ('a0IU0000000j1l4','a0IU0000000j2hE','a0IU0000001HvVQ') limit 2000")
      members.each do |m|
        begin
          badgeville_member = Badgeville.get_player_by_email(m['Name'].downcase+'@m.cloudspokes.com')
          if badgeville_member.has_key?('data')
            # find the member in sfdc
            sfdc_member = Member__c.find(m['Id'])
            if badgeville_member['data']['id'] == m['Badgeville_Id__c']
              # puts 'badgeville ids match for ' + m['Name']     
              sfdc_member.update_attributes "Badgeville_Id_Checked__c" => true
            else
              puts "==== ERROR!!! badgeville ids DO NOT match for #{m['Name']} so updating SFDC. Salesforce=#{m['Badgeville_Id__c']} & Badgeville=#{badgeville_member['data']['id']}"
              sfdc_member.update_attributes "Badgeville_Id_Checked__c" => true, "Badgeville_Id__c" => badgeville_member['data']['id']
            end
            # update the member in sfdc
            sfdc_member.save
          else
            puts "==== ERROR!!! Could not find a player for #{m['Name']}@m.cloudspokes.com"   
          end
        rescue Exception => exc
          puts "==== Bad email address: #{exc.message}" 
        end  
      end
    end
    render :text => "Done"
  end  

  # can update the user's email but not the player's
  def update_user_player_email(username)
    user = Badgeville.get_user_by_email_upper(username+'@m.cloudspokes.com')
    player = Badgeville.get_player_by_email(username+'@m.cloudspokes.com')
    puts "id: #{user['data']['_id']}"
    puts "user: #{user['data']}"
    puts "player: #{player['data']}"
    member = Members.find_by_username(current_access_token, username, DEFAULT_MEMBER_FIELDS)[0]
    user_results = Badgeville.update_user(member['Badgeville_Id__c'], username, username+'@m.cloudspokes.com')
    puts "==== update user results: #{user_results}"
    player_results = Badgeville.update_player(member)
    puts "==== update player results: #{player_results}"
  end

  def update_badgeville_player
    results = Badgeville.update_player(Members.find_by_username(current_access_token, params[:membername], DEFAULT_MEMBER_FIELDS)[0])
    render :text => "Updated #{params[:membername]} in Badgeville with results: #{results}"
  end

  def create_badgeville_user
    member = Members.find_by_username(current_access_token, params[:membername], DEFAULT_MEMBER_FIELDS)[0]
    email = member['Name']+'@m.cloudspokes.com'
    username = member['Name']
    puts "==== PROCESSING #{username} & #{email}"
    results = Badgeville.get_user_by_email(email)
    if results.has_key?('error') 
      puts "**** Creating a user for #{username} via resque ****"
      Resque.enqueue(NewBadgeVilleUser, current_access_token, username, email) 
    else
      puts "==== #{username} already exists: #{results}"
    end
    render :text => 'Done!'
  end  

  def create_badgeville_users
    connection = SfdcConnection.admin_dbdc_client
    @users = connection.query("select id, name from member__c where badgeville_id__c = '' and id not in ('a0IU0000001Ld8L') order by createddate desc limit 200")
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

  def cache_stats
    @results = Services.submit_platform_stats_job(current_access_token)
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
