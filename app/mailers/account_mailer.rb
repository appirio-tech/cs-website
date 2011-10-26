class AccountMailer < ActionMailer::Base
  default from: "vzmind@gmail.com"
  def password_recovery(account)
    @account = account
    @url  = "http://example.com/login"
    mail(:to => "#{account['Name']} <#{account['Email__c']}>", :subject => "Here is your link to renew your password")
  end
  
end
