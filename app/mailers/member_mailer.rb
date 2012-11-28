class MemberMailer < ActionMailer::Base
  default from: "CloudSpokes Team <support@cloudspokes.com>"
  
  def welcome_email(username, email)
    @username = username
    mail(:to => "#{username} <#{email}>", :subject => "Thank you for registering #{username}")
  end

  def welcome_email_from_import(membername, email, temp_password, subject, partner_name)
    @membername = membername
    @temp_password = temp_password
    @partner_name = partner_name
    mail(:to => "#{membername} <#{email}>", :subject => subject)
  end  
  
  def new_challenge_comment(email, id, name, username, profile_pic, comments, reply_to)
    @challenge_name = name
    @challenge_id = id
    @username = username
    @profile_pic = profile_pic
    @comments = comments
    @reply_to_id = reply_to
    mail(:to => email, :subject => "New Comment for '#{name}' Challenge")
  end 

  def invite(membername, email)
    @membername = membername
    mail(:to => email, :subject => "#{membername} invites you to join CloudSpokes!")
  end   
  
end