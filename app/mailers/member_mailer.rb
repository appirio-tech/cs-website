class MemberMailer < ActionMailer::Base
  default from: "CloudSpokes Team <support@cloudspokes.com>"
  
  def welcome_email(username, email)
    @username = username
    mail(:to => "#{username} <#{email}>", :subject => "Thank you for registering #{username}")
  end
  
  def new_challenge_comment(id, name, username, profile_pic, comments, reply_to)
    @challenge_name = name
    @challenge_id = id
    @username = username
    @profile_pic = profile_pic
    @comments = comments
    @reply_to_id = reply_to
    mail(:subject => "New Comment for '#{name}' Challenge")
  end  
  
end