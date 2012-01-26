class Scoring 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 

  def self.outstanding_scorecards(access_token) 
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+'/scoring/outstanding')
  end 
  
  def self.scorecard(access_token, participant, reviewer) 
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+"/scorecard/#{participant}?reviewer=#{reviewer}")
  end
  
  def self.save_scorecard(access_token, participantId, xml, scored, delete_participant_submission)
    set_header_token(access_token) 
    options = { :body => xml }
    response = put(ENV['SFDC_REST_API_URL']+"/scorecard?participantId=#{participantId}&setScored=#{scored}&deleteSubmission=#{delete_participant_submission}", options)
    Rails.logger.info "[Scoring]==== returned from score card response #{response}"
    return {:success => response['Success'].downcase, :message => response['Update Result']}
  end
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end
  
end