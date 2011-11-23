class Utils
  
  include HTTParty 
  
  # fetch the public access token from the database
  def self.public_access_token

    # get the current settings
    s = Settings.first
        
    # if the settings are older than an hour, fetch a new access token from sfdc
    if Time.now > 60.minutes.since(s.created_at.getlocal)
      
      Rails.logger.info "[Utils]==== public_access_token has expired. fetching a new one." 
      
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      Rails.logger.info "[Utils]==== logging into salesforce with #{ENV['sfdc_username']} and #{ENV['sfdc_password']}"

      # log into sfdc with their credentials to return their access token
      begin
        access_token = client.authenticate :username => ENV['sfdc_username'], :password => ENV['sfdc_password']
        # delete the existing token in the database
        s.destroy
        # add the new record
        s = Settings.new(:access_token => access_token)
        s.save
        return s.access_token 
      rescue Exception => exc
        p exc.message
        Rails.logger.error "[Utils]==== Utils could not authentiate with gem for access_token: #{exc.message}"
        return nil
      end
      
    else 
      return s.access_token  
    end
    
  end
    
  def self.send_mail(params)
    Rails.logger.info "[Utils]==== sending welcome email to #{params[:email]}"
    Resque.enqueue(WelcomeEmailSender, params[:email], params[:name], params[:subject], params[:content])    
  end
  
  def self.get_home_page(access_token, id)
    
    format :json
    headers 'Content-Type' => 'application/json'
    headers 'Authorization' => "OAuth #{access_token}"  
    request_url  = ENV['sfdc_instance_url']+'/services/data/v20.0/sobjects/home_page__c/' + id + '?fields=Featured_Challenge__r.Id__c,Featured_Challenge__r.Name,Featured_Challenge__r.Top_Prize__c,Featured_Challenge__r.Description__c,Featured_Member__r.Name,Featured_Member__r.Profile_Pic__c,Featured_Member__r.Total_Wins__c,Featured_Member__r.Active_Challenges__c,Featured_Member__r.Total_Money__c,Open_Challenges__c,Won_Challenges__c,Money_Up_for_Grabs__c,Money_Pending__c,Entries_Submitted__c,Members__c'
    page = get(request_url)
  end
  
  
  
end