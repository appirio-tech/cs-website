class Utils
  
  include HTTParty 
  #format :json
  
  def self.send_mail(params)
      
    options = {
      :body => {
          :mailUsername => 'CloudSpokes',
          :mailPassword => 'Appirio11',
          :toAddress  => 'jeff@appirio.com',
          :toAddressName => 'Jeff Douglas',
          :fromAddress => params[:email],
          :fromAddressName => params[:name], 
          :subject => 'Contact Us from CloudSpokes',
          :content => params[:content]  
      }
    }
    post('http://cs-mailchimp-mailer.herokuapp.com/sendSimpleMail', options)
    
  end
  
end