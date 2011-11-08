class User < ActiveRecord::Base
  require 'services'
  
  validates :username, :presence => true, 
            :uniqueness => true
  validates :password, :presence => true
  validates :sfdc_username, :presence => true
  
  def self.authenticate(username, password)
        
    # make sure their sfdc credentials are correct
    login_results = sfdc_login(username, password)
    p login_results
    
    if login_results[:success].eql?('true')
      # check for an existing record in the database and delete it
      user = find_by_username(username)
      user.destroy unless user.nil?
      # create the new user in the database
      user = User.new(:username => username, :sfdc_username => username+ENV['sfdc_username_domain'], 
        :password => password, :access_token => login_results[:access_token])
      user.save
      return user
    else
      # TODO pass the error back from login_results - 'message'
      return nil
    end
  end
  
  def self.authenticate_third_party(access_token, third_party_service, third_party_username)
    
    # find their sfdc username and cloudspokes username
    results = Services.sfdc_username(access_token, third_party_service, third_party_username)
    p '======= sfdc_username'
    p results
    if results[:success].eql?('true')
      
      # not make sure their credentials are correct and get their access token
      login_results = sfdc_login(results[:username], ENV['third_party_password'])
      p '========== sfdc_login results'
      p login_results
      
      # if they logged in successfully, then they are golden
      if login_results[:success].eql?('true')
      
        user = find_by_username(results[:username])
        # TODO - change this so that access token is persisted each time
        if user.nil?
          user = User.new(:username => results[:username], :sfdc_username => results[:sfdc_username], 
            :password => ENV['third_party_password'], :access_token => login_results[:access_token])
          user.save
        end
        return user
        
      else
        return nil
      end
    else
      return nil
    end
  end
  
  def self.sfdc_login(username, password)
    
    p '============ running sfdc_login'

    config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
    client = Databasedotcom::Client.new(config)
    sfdc_username = username+'@'+ENV['sfdc_username_domain']
    puts "--- logging into salesforce with #{sfdc_username} and #{password}"

    # log into sfdc with their credentials to return their access token
    begin
      access_token = client.authenticate :username => sfdc_username, :password => password
      return {:success => 'true', :message => 'Successful sfdc login.', :access_token => access_token}
    rescue Exception => exc
      return {:success => 'false', :message => exc.message}
    end

  end 
  
  def self.authenticate_with_salt(id)
    user = find_by_id(id)
    # (user && user.salt == cookie_salt) ? user : nil
  end 
            
end
