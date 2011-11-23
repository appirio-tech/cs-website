class Services 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end
  
  # creates a new member -- either directly or from third party service
  def self.new_member(access_token, params)
    set_header_token(access_token)
          
    if params.has_key?(:provider)
      
      # split up the name into a first and last
      names = params[:name].split
      first_name = names[0]
      if names.length > 1
        last_name = names[1]
      else
        last_name = first_name
      end
      
      options = {
        :body => {
            :username__c => params[:username],
            :email__c  => params[:email],
            :first_name__c => first_name,
            :last_name__c => last_name,
            :third_party_account__c => params[:provider],
            :third_party_username__c => params[:username],
        }
      }
            
    else

      options = {
        :body => {
            :username__c => params[:username],
            :password => params[:password],
            :email__c  => params[:email],
            :first_name__c => params[:username],
            :last_name__c => params[:username] 
        }
      }

    end    
    
    Rails.logger.info "[Services]==== making the call to create the user for #{options}"         
    results = post(ENV['sfdc_rest_api_url']+'/members', options)
                
    begin
      
      Rails.logger.info "[Services]==== results from the create new user call: #{results}" 
      
      if results['Success'].eql?('true')
        return {:success => 'true', :username => results["username"], 
          :sfdc_username => results["sfdc_username"], :message => results["Message"]}
      else
        Rails.logger.warn "[Services]==== could not create new user. sfdc replied: #{results["Message"]}" 
        return {:success => 'false', :message => results["Message"]}
      end

    rescue
      Rails.logger.error "[Services]==== fatal error creating new user: #{results[0]['message']}" 
      return {:success => 'false', :message => results[0]['message']}
    end
    
  end
  
  # returns the username and sfdc usersname for third party credentals
  def self.sfdc_username(access_token, third_party_service, third_party_username)  
    set_header_token(access_token)
    
    options = {
      :query => {
          :username => third_party_username,
          :service  => third_party_service
      }
    }

    results = get(ENV['sfdc_rest_api_url']+'/credentials', options)
            
    begin
      if results['Success'].eql?('true')
        return {:success => 'true', :username => results["Username"], :sfdc_username => results["SFusername"]}
      else
        Rails.logger.error "[Services]==== error getting sfdc username: #{results["Message"]}" 
        return {:success => 'false', :message => results["Message"]}
      end
    # something bad.. probably expired token
    rescue Exception => exc
      Rails.logger.error "[Services]==== fatal error getting sfdc username: #{results[0]['message']}" 
      return {:success => 'false', :message => results[0]['message']}
    end
    
  end
  
end