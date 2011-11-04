class NewChallengeCommentSender
  include HTTParty 
  
  @queue = :challenge_comments_queue
  def self.perform(access_token, id, username, comments)
      
    # fetch the challenge to get all of the participants
    challenge = Challenges.find_by_id(access_token, id)[0]
    # create the actual email
    mail = MemberMailer.new_challenge_comment(id, challenge["Name"], username, comments)
    # create an array to hold all of the addresses
    addresses = Array.new
    # add the owner of the challenge
    addresses.push(challenge["Owner"]["Email"])
    # add everyone that is registered or watching
    challenge["Challenge_Participants__r"]["records"].each do |record|
      addresses.push(record["Member__r"]["Email__c"])
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
      p "===> email send results for #{to_address}: #{results}"
    
    }
    
  end
  
end