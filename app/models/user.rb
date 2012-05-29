class User < ActiveRecord::Base
  require 'services'
  
  validates :username, :presence => true, 
            :uniqueness => true
  validates :password, :presence => true
  validates :sfdc_username, :presence => true
  validates_format_of :sfdc_username, :with => /\@/
  
  # called from sessions_controller when logging in using cs credentials
  def self.authenticate(access_token, username, password)
        
    # make sure their sfdc credentials are correct
    login_results = sfdc_login(username, password)
    
    if login_results[:success].eql?('true')
      # get their member record and profile_pic
      member = Members.find_by_username(access_token, username, 'id,profile_pic__c,email__c,account__c').first      
      # check for an existing record in the database and delete it
      User.delete(User.find_by_username(username))
      # create the new user in the database
      user = User.new(:username => username, :sfdc_username => username+'@'+ENV['SFDC_USERNAME_DOMAIN'], 
        :password => password, :access_token => login_results[:access_token], 
        :profile_pic => member['Profile_Pic__c'], :email => member['Email__c'], :accountid => member['Account__c'])
      user.save
      return user
    else
      logger.error "[User]==== could not authenticate user in sfdc: #{login_results.to_yaml}"
      return nil
    end
  end
  
  # called only from sessions_controller's oauth callback if the user already exists.
  def self.authenticate_third_party(access_token, third_party_service, third_party_username)
    
    # find their sfdc username and cloudspokes username
    results = Services.sfdc_username(access_token, third_party_service, third_party_username)

    if results[:success].eql?('true')
      
      # not make sure their credentials are correct and get their access token
      login_results = sfdc_login(results[:username], ENV['THIRD_PARTY_PASSWORD'])
      
      # if they logged in successfully, then they are golden
      if login_results[:success].eql?('true')
        
        # delete the user if they already exists in pg
        User.delete(User.find_by_username(results[:username]))
        # save the user
        user = User.new(:username => results[:username], :sfdc_username => results[:sfdc_username], 
            :password => ENV['THIRD_PARTY_PASSWORD'], :access_token => login_results[:access_token],
            :profile_pic => results[:profile_pic], :email => results[:email], :accountid => results[:accountid])
        logger.error "[User]==== could not save user to database: #{user.errors.full_messages}" unless user.save
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
  
  # this method only called from this user class
  def self.sfdc_login(username, password)
    
    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    sfdc_username = username+'@'+ENV['SFDC_USERNAME_DOMAIN']
    logger.info "[User]==== logging into salesforce with sfdc username: #{sfdc_username}"

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
