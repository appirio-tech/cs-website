class SiteSettings

  # --------------------- should not be needed any longer
  def self.get_new_public_access_token
    
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    puts "--- logging into salesforce with #{ENV['sfdc_username']} and #{ENV['sfdc_password']}"

    # log into sfdc with their credentials to return their access token
    begin
      access_token = client.authenticate :username => ENV['sfdc_username'], :password => ENV['sfdc_password']
      p '======== access_token'
      p access_token
      p '======= client'
      p client
      # delete the existing token
      s = Settings.first
      s.destroy unless s.nil?
      # add the new record
      s = Settings.new(:access_token => access_token)
      s.save
    rescue Exception => exc
      # TODO - log some fatal error and notify cloudspokes!!
      p exc.message
    end
    
  end

  # fetch the public access token from the database
  def self.public_access_token

    # get the current settings
    s = Settings.first
        
    # if the settings are older than an hour, fetch a new access token from sfdc
    if Time.now > 60.minutes.since(s.created_at.getlocal)
      
      p '=========== public_access_token has expired. fetching a new one.'
      
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      puts "--- logging into salesforce with #{ENV['sfdc_username']} and #{ENV['sfdc_password']}"

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
        # TODO - log some fatal error and notify cloudspokes!!
        p exc.message
        return nil
      end
      
    else 
      p "=========== returning publics_access_token from database #{s.access_token}"
      return s.access_token  
    end
    
  end

end