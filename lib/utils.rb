class Utils
    
  def self.send_mail(params)
    Resque.enqueue(WelcomeEmailSender, params[:email], params[:name], params[:subject], params[:content])    
  end
  
end