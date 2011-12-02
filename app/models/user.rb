class User < ActiveRecord::Base
  require 'services'
  
  validates :username, :presence => true, 
            :uniqueness => true
  validates :password, :presence => true
  validates :sfdc_username, :presence => true
  
  def self.authenticate(username, password)
        
    # make sure their sfdc credentials are correct
    login_results = sfdc_login(username, password)
    
    if login_results[:success].eql?('true')
      # check for an existing record in the database and delete it
      user = find_by_username(username)
      user.destroy unless user.nil?
      # create the new user in the database
      user = User.new(:username => username, :sfdc_username => username+ENV['SFDC_USERNAME_DOMAIN'], 
        :password => password, :access_token => login_results[:access_token])
      user.save
      return user
    else
      # TODO pass the error back from login_results - 'message'
      logger.error "[User]==== could not authenticate user in sfdc: #{login_results.to_yaml}"
      return nil
    end
  end
  
  def self.authenticate_third_party(access_token, third_party_service, third_party_username)
    
    # find their sfdc username and cloudspokes username
    results = Services.sfdc_username(access_token, third_party_service, third_party_username)

    if results[:success].eql?('true')
      
      # not make sure their credentials are correct and get their access token
      login_results = sfdc_login(results[:username], ENV['THIRD_PARTY_PASSWORD'])
      
      # if they logged in successfully, then they are golden
      if login_results[:success].eql?('true')
      
        user = find_by_username(results[:username])
        # TODO - change this so that access token is persisted each time
        if user.nil?
          user = User.new(:username => results[:username], :sfdc_username => results[:sfdc_username], 
            :password => ENV['THIRD_PARTY_PASSWORD'], :access_token => login_results[:access_token])
          user.save
        end
        return user
        
      else
        logger.error "[User]==== could not authenticate via third party credentials: #{login_results.to_yaml}"
        return nil
      end
    else
      logger.error "[User]==== could not authenticate via third party credentials. could not fetch sfdc username: #{results.to_yaml}"
      return nil
    end
  end
  
  def self.sfdc_login(username, password)
    
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    sfdc_username = username+'@'+ENV['SFDC_USERNAME_DOMAIN']
    logger.info "[User]==== logging into salesforce with #{sfdc_username} and #{password}"

    # log into sfdc with their credentials to return their access token
    begin
      access_token = client.authenticate :username => sfdc_username, :password => password
      return {:success => 'true', :message => 'Successful sfdc login.', :access_token => access_token}
    rescue Exception => exc
      logger.error "[User]==== using gem to authenticate to get access_token: #{exc.message}"
      return {:success => 'false', :message => exc.message}
    end

  end 
  
  def self.authenticate_with_salt(id)
    user = find_by_id(id)
  end 
            
end
