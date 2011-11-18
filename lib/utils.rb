class Utils
  
  include HTTParty 
    
  def self.send_mail(params)
    Resque.enqueue(WelcomeEmailSender, params[:email], params[:name], params[:subject], params[:content])    
  end
  
  def self.get_home_page(access_token, id)
    
    format :json
    headers 'Content-Type' => 'application/json'
    headers 'Authorization' => "OAuth #{access_token}"  
    request_url  = ENV['sfdc_instance_url']+'/services/data/v20.0/sobjects/home_page__c/' + id + '?fields=Featured_Challenge__r.Id__c,Featured_Challenge__r.Name,Featured_Challenge__r.Top_Prize__c,Featured_Challenge__r.Description__c,Featured_Member__r.Name,Featured_Member__r.Profile_Pic__c,Featured_Member__r.Total_Wins__c,Featured_Member__r.Active_Challenges__c,Featured_Member__r.Total_Money__c,Open_Challenges__c,Won_Challenges__c,Money_Up_for_Grabs__c,Money_Pending__c,Entries_Submitted__c,Members__c'
    page = get(request_url)
    p '======= the home page'
    p page
  end
  
  
  
end