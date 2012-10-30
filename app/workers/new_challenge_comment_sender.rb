class NewChallengeCommentSender
  include HTTParty 
  
  @queue = :challenge_comments_queue
  def self.perform(access_token, id, username, comments, reply_to)
    
    Rails.logger.info "[Resque]==== preparing to send challenge comment email. Replying to #{reply_to}"
      
    # fetch the challenge to get all of the participants
    challenge = Challenges.find_by_id(access_token, id)[0]
    # fetch the member so we can user the profile pic
    member = CsApi::Member.find_by_membername(access_token, username, 'id,profile_pic')
    # create an array to hold all of the addresses
    addresses = Array.new
    notifiers = Comments.notifiers(access_token, id, reply_to)
    notifiers.each do |email|
      addresses.push(email)
    end

    addresses.each { |to_address| 

      begin

        Rails.logger.info "[Resque]==== sending challenge comment to #{to_address}"
        # create the actual email and send it
        mail = MemberMailer.new_challenge_comment(to_address, id, challenge["Name"], username, member['profile_pic'], comments, reply_to).deliver

      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e      
        Rails.logger.info "[FATAL][Resque]==== SMTP Error sending challenge comment. Cause: #{e.message}"   
      end         

    }
    
  end
  
end