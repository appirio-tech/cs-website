require 'utils'

class ContentController < ApplicationController
  
  include HTTParty 
  format :json
  
  def contact
    @contact_form = ContactForm.new
  end
  
  def contact_send
    @contact_form = ContactForm.new(params[:contact_form])
    if @contact_form.valid?
      Utils.send_mail(params[:contact_form])
    else
      render :action => 'contact'
    end
  end
end
