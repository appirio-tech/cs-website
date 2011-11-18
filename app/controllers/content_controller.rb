require 'faqs'
require 'webpages'

class ContentController < ApplicationController
  
  def home
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    @leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_month.iso8601(0),1)["data"])
    @members = 50061.1
    @challenes_open = 17.0
    @chalenges_won = 347.0
    @money_up_for_grabs = 11459
    @money_pending = 287987
    @entries_submitted = 589.0
    @featured_challenge = {'id' => 4, 'name' => "Search for Members with Redis", 'top_prize' => "$1000", 'details' => "Redis, <b>and</b> NoSQL in general, is all the rage right now and what is not to love? Redis is an extremely fast, atomic key-value store f sdf asdf adfasdfasdfa fa..."}
    @featured_member = {'username' => 'testmember1', 'money' => 16589, 'active' => 3, 'wins' => 11, 'picture' => 'https://acdcstorage.blob.core.windows.net/userimages/profilekenji776038c1f86-598e-4488-a13d-02ff065ebe17_th_100.jpg'}
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