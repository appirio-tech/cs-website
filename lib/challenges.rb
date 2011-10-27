require 'cloud_spokes'
class Challenges < Cloudspokes
    
  # this method may go away
  def self.get_challenges(access_token, show_open, orderby, category)
    
    qry_open = show_open ? '&open=true' : '&open=false'
    qry_orderby = '&orderby='+orderby
    qry_category = category.nil? ? '' : '&category='+CGI::escape(category)
    
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challengesearch?fields=Id,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c'+qry_orderby+qry_open+qry_category)
  end
  
  #this member may go away
  def self.get_challenges_by_keyword(access_token, keyword)  
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challengesearch?fields=Id,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c&search='+keyword)
  end
    
  def self.get_categories(access_token, id)
    set_header_token(access_token) 
    catnames = []
    cats = get(ENV['sfdc_rest_api_url']+'/challenges/'+id+'/categories?fields=id,name,display_name__c')
    p cats
    cats.each do |cat|
      catnames.push(cat['Display_Name__c'])
    end
    return catnames
  end
  
  def self.get_prizes(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challenges/'+id+'/prizes?fields=Prize__c,Place__c')
  end
  
  def self.get_registrants(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/participants?challengeid='+id+'&fields=Member__r.Profile_Pic__c,Member__r.Name,Member__r.Total_Wins__c')
  end
  
  def self.get_leaderboard(access_token, from_date, page_num)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/leaderboard?pageNum='+page_num.to_s+'&dateFormat='+from_date.to_s)
  end
end