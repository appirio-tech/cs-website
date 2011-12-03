class WelcomeEmailSender
  include HTTParty 
  
  @queue = :welcome_email_queue
  def self.perform(access_token, username)
    
    # fetch the member's email address from sfdc
    member_results = Members.find_by_username(access_token, username,'Email__c')[0]
    
    # generate the mail to send
    mail = MemberMailer.welcome_email(username)

    options = {
      :body => {
          :mailUsername => ENV['MAILER_USERNAME'],
          :mailPassword => ENV['MAILER_PASSWORD'],
          :toAddress  => member_results['Email__c'],
          :toAddressName => username,
          :fromAddress => 'support@cloudspokes.com',
          :fromAddressName => 'CloudSpokes Team', 
          :subject => mail.subject.to_s,
          :content => mail.body.to_s  
      }
    }
    results = post('http://cs-mailchimp-mailer.herokuapp.com/sendSimpleMail', options)
    Rails.logger.info "[Resque]==== welcome email send results for #{member_results['Email__c']}: #{results}"
    
  end
  
end