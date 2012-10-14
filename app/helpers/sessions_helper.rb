module SessionsHelper

  def cs_login_error_message(message)
    if message.include?('Password Lockout')
      'LOCKED OUT -- You have been locked out for 10 invalid login attempts. 
        Please wait 15 minutes before attempting to login again.'
    elsif message.include?('Invalid Password')
      'Invalid username/password combination. Try the Forgot 
        Password? link below to reset your password.'
    else
      message
    end
  end
  
  def thirdparty_username(auth)
    if ['github','twitter'].include?(auth[:provider]) 
      auth[:username]
    else
      auth[:email]
    end
  end
    
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id]
    self.current_user = user
  end
  
  def sign_out
    current_user.destroy unless current_user.nil?
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil]
    end
  
end
