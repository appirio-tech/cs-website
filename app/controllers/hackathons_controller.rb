class HackathonsController < ApplicationController
  include Databasedotcom::Rails::Controller
  
  layout "hackathon"

  def show
    
    @hack = dbdc_client.query("select Id, Name, Location__c, Location_Address__c, Location_City__c, Location_State__c, Location_Zip__c, Start_Date__c, 
      End_Date__c, About__c, Register__c, Account__c, Twitter_Hashtag__c, Header_HTML__c, Footer_HTML__c, Logo__c 
      from Hackathon__c where hackathon_id__c = '#{params[:id]}'").first
      
    @sponsors = dbdc_client.query("select Id, Name, Logo__c, Home_Page__c, Event_Page__c, Type__c
      from Hackathon_Sponsor__c where hackathon__c = '#{@hack['Id']}' order by display_order__c")
      
    @links = dbdc_client.query("select Id, Name, URL__c, Description__c from Hackthon_Link__c
      where hackathon__c = '#{@hack['Id']}'")            
      
    @prizes = dbdc_client.query("select id, prize__c, value__c, hackathon_sponsor__r.name from challenge_prize__c 
      where challenge__c in (select id from challenge__c where hackathon__c = '#{@hack['Id']}') order by value__c desc")   
      
    @challenges = dbdc_client.query("select Id, Name, Challenge_Id__c, End_Date__c, Description__c from Challenge__c where hackathon__c = '#{@hack['Id']}'")         
      
    @prize_total = 0
		@prizes.each do |prize|
		  @prize_total = @prize_total + prize['Value__c']
		end
      
  end

  def results
  end

  def page
  end
  
  private 
  
    def dbdc_client
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      client.authenticate :username => current_user.sfdc_username, :password => current_user.password
      return client
    end

end
