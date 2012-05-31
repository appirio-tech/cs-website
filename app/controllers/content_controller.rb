require 'faqs'
require 'webpages'
require 'utils'

class ContentController < ApplicationController
  
  caches_page :notifications
  before_filter :redirect_to_http
  
  def redirect_to_http
    redirect_to url_for params.merge({:protocol => 'http://'}) unless !request.ssl?
  end
  
  def notifications
    render :json => Utils.shared_dbdc_client.query("select id, name, url__c from Site_Notification__c")
  end
  
  def home
    @page_title = "A unique cloud development community, focused on mobile technologies and public cloud platforms."
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'home')

    @featured_member_username = @page['featured_member_username']
    @featured_member_pic = @page['featured_member_pic']
    @featured_member_money = @page['featured_member_money']
    @featured_member_active = @page['featured_member_active']
    @featured_member_wins = @page['featured_member_wins']
    
    @members = @page['members']
    @challenes_open = @page['challenes_open']
    @chalenges_won = @page['chalenges_won']
    @money_up_for_grabs = @page['money_up_for_grabs']
    @money_pending = @page['money_pending']
    @entries_submitted = @page['entries_submitted']
    
    @featured_challenge_id = @page['featured_challenge_id']
    @featured_challenge_name = @page['featured_challenge_name']
    @featured_challenge_prize = @page['featured_challenge_prize']
    @featured_challenge_details = @page['featured_challenge_details']
    
    @leaders = Challenges.get_leaderboard(current_access_token, :period => 'all')
    
    respond_to do |format|
      format.html
      format.json { render :json => @page }
    end
    
  end
  
  def welcome
    @page_title = "A unique development community, focused on mobile technologies and public cloud platforms."
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'welcome')
  end
  
  def login_help
    @page_title = "Need Help Loggin In?"
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'login_help')
  end
  
  def faq
    @page_title = "FAQs"
    @faqs = FAQs.all(current_access_token, :select => 'name,answer__c', :orderby => 'Display_Order__c')
  end
  
  def about
    @page_title = "How CloudSpokes Works"
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'about')
  end
  
  def privacy
    @page_title = "Privacy Policy"
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'privacy')
  end
  
  def tos
    @page_title = "Terms of Service"
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'tos')
  end
  
  def login_denied
    @page_title = "Login Denied"
    @page = Webpages.all(current_access_token, :select => 'id,html__c', :where => 'login_denied')
  end

end