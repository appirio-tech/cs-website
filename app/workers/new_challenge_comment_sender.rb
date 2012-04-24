class NewChallengeCommentSender
  include HTTParty 
  
  @queue = :challenge_comments_queue
  def self.perform(access_token, id, username, comments, reply_to)
    
    Rails.logger.info "[Resque]==== preparing to send challenge comment email. Replying to #{reply_to}"
      
    # fetch the challenge to get all of the participants
    challenge = Challenges.find_by_id(access_token, id)[0]
    # fetch the member so we can user the profile pic
    member = Members.find_by_username(access_token, username, 'id,profile_pic__c').first
    # create the actual email
    mail = MemberMailer.new_challenge_comment(id, challenge["Name"], username, member['Profile_Pic__c'], comments, reply_to)
    # create an array to hold all of the addresses
    addresses = Array.new
    notifiers = Comments.notifiers(access_token, id, reply_to)
    notifiers.each do |email|
      addresses.push(email)
    end

    addresses.each { |to_address| 
    
      options = {
        :body => {
            :mailUsername => ENV['MAILER_USERNAME'],
            :mailPassword => ENV['MAILER_PASSWORD'],
            :toAddress  => to_address,
            :toAddressName => to_address,
            :fromAddress => 'support@cloudspokes.com',
            :fromAddressName => 'CloudSpokes Team', 
            :subject => mail.subject.to_s,
            :content => mail.body.to_s  
        }
      }
      results = post('http://cs-mailchimp-mailer.herokuapp.com/sendSimpleMail', options)
      Rails.logger.info "[Resque]==== challenge comment email send results for #{to_address}: #{results}"
    
    }
    
  end
  
end