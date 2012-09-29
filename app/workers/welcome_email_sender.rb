class WelcomeEmailSender
  include HTTParty 
  
  @queue = :welcome_email_queue
  def self.perform(access_token, membername)
    
    # fetch the member's email address from sfdc
    member_results = Members.find_by_username(access_token, membername,'Email__c')[0]

    begin

      Rails.logger.info "[Resque]==== sending welcome email to member #{membername} at #{member_results['Email__c']}"
      # generate the mail to send and send it
      mail = MemberMailer.welcome_email(membername, member_results['Email__c']).deliver

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e      
      Rails.logger.info "[Resque]==== SMTP Error sending 'Welcome Email'! Cause: #{e.message}"   
    end       

  end
  
end