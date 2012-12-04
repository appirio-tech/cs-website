class User < ActiveRecord::Base
  
  validates :username, :presence => true, 
            :uniqueness => true
  validates :password, :presence => true
  validates :sfdc_username, :presence => true
  validates_format_of :sfdc_username, :with => /\@/
  
  # called from sessions_controller when logging in using cs credentials
  def self.authenticate(access_token, username, password)
        
    login_results = CsApi::Account.authenticate(username, password).symbolize_keys!
    logger.info "[User]==== Authentication with cs-api for #{username}: #{login_results}"
    
    if login_results[:success].eql?('true')
      # get their member record and profile_pic
      member = CsApi::Member.find_by_membername(access_token, username, 'id,profile_pic,email,account')
      puts member.to_yaml
      # check for an existing record in the database and delete it
      User.delete(User.find_by_username(username))
      # create the new user in the database
      user = User.new(:username => username, :sfdc_username => username+'@'+ENV['SFDC_USERNAME_DOMAIN'], 
        :password => Encryptinator.encrypt_string(password), :access_token => login_results[:access_token], 
        :profile_pic => member['profile_pic'], :email => member['email'], :accountid => member['account'])
      puts user.to_yaml
      user.save
      { :user => user, :message => login_results[:message] }
    else
      logger.error "[User]==== could not authenticate user in sfdc: #{login_results.to_yaml}"
      { :user => nil, :message => login_results[:message] }
    end
  end
  
  # called only from sessions_controller's oauth callback if the user already exists.
  def self.authenticate_third_party(access_token, third_party_service, third_party_username)
    
    # find their sfdc username and cloudspokes username
    results = CsApi::Account.find_by_service(third_party_service, third_party_username).symbolize_keys!

    if results[:success].eql?('true')
      
      # not make sure their credentials are correct and get their access token
      login_results = CsApi::Account.authenticate(results[:username], ENV['THIRD_PARTY_PASSWORD']).symbolize_keys!
      logger.info "[User]==== Authentication with cs-api for #{:username}: #{login_results}"
      
      # if they logged in successfully, then they are golden
      if login_results[:success].eql?('true')
        
        # delete the user if they already exists in pg
        User.delete(User.find_by_username(results[:username]))
        # save the user
        user = User.new(:username => results[:username], :sfdc_username => results[:sfdc_username], 
            :password => Encryptinator.encrypt_string(ENV['THIRD_PARTY_PASSWORD']), :access_token => login_results[:access_token],
            :profile_pic => results[:profile_pic], :email => results[:email], :accountid => results[:accountid])
        logger.error "[User]==== could not save user to database: #{user.errors.full_messages}" unless user.save
        user
        
      else
        logger.error "[User]==== could not authenticate via third party credentials: #{login_results.to_yaml}"
        nil
      end
    else
      logger.error "[User]==== could not authenticate via third party credentials. could not fetch sfdc username: #{results.to_yaml}"
      nil
    end
  end
  
  def self.authenticate_with_salt(id)
    user = find_by_id(id)
  end 
            
end
