class SfdcConnection
  
  include HTTParty 
  
  # fetch the public access token from the database
  def self.public_access_token

    # get the current settings
    s = Settings.first
        
    # if the settings are older than an hour, fetch a new access token from sfdc
    if Time.now > 60.minutes.since(s.created_at.getlocal)
      
      Rails.logger.info "[SfdcConnection]==== public_access_token has expired. fetching a new one." 
      
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      Rails.logger.info "[SfdcConnection]==== logging into salesforce with #{ENV['SFDC_USERNAME']} and #{ENV['SFDC_PASSWORD']}"

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
        Rails.logger.error "[SfdcConnection]==== SfdcConnection could not authentiate with gem for access_token: #{exc.message}"
        return nil
      end
      
    else 
      return s.access_token  
    end
    
  end
  
  # fetch the access token for the specific current member
  def self.member_access_token(current_user)
        
    # if the access token is nil or the access token hasn't been updated in an hour
    if current_user.access_token.nil? || Time.now > current_user.updated_at.getlocal + (60*60)
    
      Rails.logger.info "[SfdcConnection]==== access token for #{current_user.username} is nil or an hour old (token last updated: #{current_user.updated_at.getlocal}). fetching new access token."
    
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      sfdc_username = current_user.username+'@'+ENV['SFDC_USERNAME_DOMAIN']
      Rails.logger.info "[SfdcConnection]==== logging into salesforce with for a new access token for sfdc username: #{sfdc_username}"
    
      begin

        access_token = client.authenticate :username => sfdc_username, :password => Encryptinator.decrypt_string(current_user.password)
        current_user.access_token = access_token
        # try and save the record now
        Rails.logger.error "[SfdcConnection]==== could not save new access_token to the datbase for #{current_user.username} / #{Encryptinator.decrypt_string(current_user.password)}. Error: #{user.errors.full_messages}" if !current_user.save
        # touch the record to update the updated_at time if no values were changed
        current_user.touch
        return current_user.access_token

      # seem to get this error for brand new users after they are created
      # if we get an error, just return the public_access_token. it will check again on the
      # next call to this method until it returns the access_token successfully
      rescue Exception => exc
        Rails.logger.warn "[SfdcConnection]==== error getting the access_token for #{current_user.username} / #{Encryptinator.decrypt_string(current_user.password)}. returning public_access_token instead. sfdc returned error: #{exc.message}"
        return SfdcConnection.public_access_token
      end
    
    # the access token not nil and less than an hour old. just return it
    else
      return current_user.access_token
    end
    
  end
  
  def self.admin_dbdc_client
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    client.debugging = false
    client.authenticate :username => ENV['SFDC_ADMIN_USERNAME'], :password => ENV['SFDC_ADMIN_PASSWORD']
    return client
  end

  def self.dbdc_client(access_token)
    client = Databasedotcom::Client.new
    client.debugging = true
    client.authenticate :token => access_token, :instance_url => ENV['SFDC_INSTANCE_URL']
    return client
  end
  
end