class MemberMailer < ActionMailer::Base
  default from: "support@cloudspokes.com"
  
  def welcome_email(username)
    @username = username
    mail(:subject => "Thank you for registering #{username}")
  end
  
  def new_challenge_comment(id, name, username, profile_pic, comments, reply_to)
    Rails.logger.info "[Resque]==== new_challenge_comment reply for: #{reply_to}"
    @challenge_name = name
    @challenge_id = id
    @username = username
    @profile_pic = profile_pic
    @comments = comments
    @reply_to = reply_to
    mail(:subject => "New Comment for '#{name}' Challenge")
  end  
  
end