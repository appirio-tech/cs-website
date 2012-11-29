require 'cs_api_challenge'

class WelcomeEmailFromImportSender
  include HTTParty 
  
  @queue = :welcome_email_from_import_queue
  def self.perform(access_token, membername, email, temp_password, subject, partner_name)
    
    # get the collection of open challenges so we can display them in the email
    open_challenges = CsApi::Challenge.open(access_token)

    begin

      Rails.logger.info "[Resque]==== sending welcome email to member #{membername} at #{email}"
      # generate the mail to send and send it
      mail = MemberMailer.welcome_email_from_import(membername, email, temp_password, subject, partner_name, open_challenges).deliver

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e      
      Rails.logger.info "[FATAL][Resque]==== SMTP Error sending 'Welcome Email (from Import)'! Cause: #{e.message}"   
    end       

  end
  
end