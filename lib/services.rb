class Services 
  
  require 'sitesettings'
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 
  headers 'Authorization' => "OAuth #{SiteSettings.public_access_token}"
  
  # creates a new member -- either directly or from third party service
  def self.new_member(params)
          
    if params.has_key?(:provider)
      
      p '============= creating third party'
      
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
    
    p '======= options for new user in sfdc'
    p options     
         
    results = post(ENV['sfdc_instance_url']+'/members', options)
                
    begin
      
      p '====== response from new member call to sfdc'
      p results
      
      if results['Success'].eql?('true')
        return {:success => 'true', :username => results["username"], 
          :sfdc_username => results["sfdc_username"], :message => results["Message"]}
      else
        return {:success => 'false', :message => results["Message"]}
      end

    rescue
      return {:success => 'false', :message => results[0]['message']}
    end
    
  end
  
  # returns the username and sfdc usersname for third party credentals
  def self.sfdc_username(third_party_service, third_party_username)  
    
    options = {
      :query => {
          :username => third_party_username,
          :service  => third_party_service
      }
    }

    p "========= getting sfdc_username for #{third_party_service} and #{third_party_username} and public access token"
    results = get(ENV['sfdc_instance_url']+'/credentials', options)
            
    begin
    
      if results['Success'].eql?('true')
        return {:success => 'true', :username => results["Username"], :sfdc_username => results["SFusername"]}
      else
        return {:success => 'false', :message => results["Message"]}
      end
    
    # something bad.. probably expired token
    rescue Exception => exc
      return {:success => 'false', :message => results[0]['message']}
    end
    
  end
  
end