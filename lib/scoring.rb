class Scoring 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 

  def self.outstanding_scorecards(access_token) 
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/scoring/outstanding')
  end 
  
  def self.scorecard(access_token, participant, reviewer) 
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+"/scorecard/#{esc participant}?reviewer=#{esc reviewer}")
  end
  
  def self.save_scorecard(access_token, xml, scored)
    set_header_token(access_token) 
    options = { :body => xml }
    response = put(ENV['sfdc_rest_api_url']+"/scorecard?setScored=#{esc scored}", options)
    return {:success => response['Success'].downcase, :message => response['Update Result']}
  end
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end
  
end