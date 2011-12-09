module SessionsHelper
  
  def thirdparty_username(as.get_hash)
    if ['github','twitter'].include?(as.get_hash[:provider]) 
      as.get_hash[:username]
    else
      as.get_hash[:email]
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
