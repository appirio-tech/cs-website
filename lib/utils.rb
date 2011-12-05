class Utils
  
  include HTTParty 
  
  # fetch the public access token from the database
  def self.public_access_token

    # get the current settings
    s = Settings.first
        
    # if the settings are older than an hour, fetch a new access token from sfdc
    if Time.now > 60.minutes.since(s.created_at.getlocal)
      
      p "[Utils]==== public_access_token has expired. fetching a new one." 
      #Rails.logger.info "[Utils]==== public_access_token has expired. fetching a new one." 
      
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      p "[Utils]==== logging into salesforce with #{ENV['SFDC_USERNAME']} and #{ENV['SFDC_PASSWORD']}"
      #Rails.logger.info "[Utils]==== logging into salesforce with #{ENV['SFDC_USERNAME']} and #{ENV['SFDC_PASSWORD']}"

      # log into sfdc with their credentials to return their access token
      begin
        access_token = client.authenticate :username => ENV['SFDC_USERNAME'], :password => ENV['SFDC_PASSWORD']
        # delete the existing token in the database
        s.destroy
        # add the new record
        s = Settings.new(:access_token => access_token)
        s.save
        return s.access_token 
      rescue Exception => exc
        p exc.message
        p "[Utils]==== Utils could not authentiate with gem for access_token: #{exc.message}"
        #Rails.logger.error "[Utils]==== Utils could not authentiate with gem for access_token: #{exc.message}"
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
  
end