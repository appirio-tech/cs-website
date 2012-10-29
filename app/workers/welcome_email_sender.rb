class WelcomeEmailSender
  include HTTParty 
  
  @queue = :welcome_email_queue
  def self.perform(access_token, membername)
    
    # fetch the member's email address from sfdc
    member_results = CsApi::Member.find_by_membername(access_token, membername,'email')

    begin

      Rails.logger.info "[Resque]==== sending welcome email to member #{membername} at #{member_results['email']}"
      # generate the mail to send and send it
      mail = MemberMailer.welcome_email(membername, member_results['email']).deliver

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e      
      Rails.logger.info "[FATAL][Resque]==== SMTP Error sending 'Welcome Email'! Cause: #{e.message}"   
    end       

  end
  
end