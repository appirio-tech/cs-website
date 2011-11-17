require 'faqs'
require 'webpages'

class ContentController < ApplicationController
  
  def faq
    @faqs = FAQs.all(current_access_token, :select => 'name,answer__c', :orderby => 'Display_Order__c')
  end
  
  def about
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'about')[0]
  end
  
  def privacy
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'privacy')[0]
  end
  
  def tos
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'tos')[0]
  end

end