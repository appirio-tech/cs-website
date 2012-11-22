class InviteEmailSender
  include HTTParty 
  
  @queue = :invite_email_queue
  def self.perform(membername, email)
    begin
      # generate the mail to send and send it
      mail = MemberMailer.invite(membername, email).deliver
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e      
      Rails.logger.info "[FATAL][Resque]==== SMTP Error sending 'Invite Email'! Cause: #{e.message}"   
    end       
  end
  
end