require 'faqs'
require 'webpages'
require 'utils'

class ContentController < ApplicationController
  
  def home
    
    ## ALL OF THIS IS TEMP -- NEED TO MOVE IT TO POSTGRES OR REDIS
    home = Utils.get_home_page(current_access_token, 'a0eJ000000005wNIAQ')
    
    @featured_member_username = home['Featured_Member__r']['Name']
    @featured_member_pic = home['Featured_Member__r']['Profile_Pic__c']
    @featured_member_money = home['Featured_Member__r']['Total_Money__c']
    @featured_member_active = home['Featured_Member__r']['Active_Challenges__c']
    @featured_member_wins = home['Featured_Member__r']['Total_Wins__c']
    
    @members = home['Members__c']
    @challenes_open = home['Open_Challenges__c']
    @chalenges_won = home['Won_Challenges__c']
    @money_up_for_grabs = home['Money_Up_for_Grabs__c']
    @money_pending = home['Money_Pending__c']
    @entries_submitted = home['Entries_Submitted__c']
    
    @featured_challenge_id = home['Featured_Challenge__r']['ID__c']
    @featured_challenge_name = home['Featured_Challenge__r']['Name']
    @featured_challenge_prize = home['Featured_Challenge__r']['Top_Prize__c']
    @featured_challenge_details = home['Featured_Challenge__r']['Description__c']
    
    @leaders = Challenges.get_leaderboard(current_access_token, :period => 'month')
  end
  
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