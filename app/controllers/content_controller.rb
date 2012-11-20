require 'sfdc_connection'
require 'cs_api_stats'

class ContentController < ApplicationController
  before_filter :redirect_to_http
  
  def home
    @page_title = "A unique cloud development community, focused on mobile technologies and public cloud platforms."

    stats = CsApi::Stats.public(current_access_token)
    
    @featured_member_username = stats['featured_member_username']
    @featured_member_pic = stats['featured_member_pic']
    @featured_member_money = stats['featured_member_money']
    @featured_member_active = stats['featured_member_active']
    @featured_member_wins = stats['featured_member_wins']
    
    @members = stats['members']
    @challenges_open = stats['challenges_open']
    @challenges_won = stats['challenges_won']
    @money_up_for_grabs = stats['money_up_for_grabs']
    @money_pending = stats['money_pending']
    @entries_submitted = stats['entries_submitted']
    
    @featured_challenge_id = stats['featured_challenge_id']
    @featured_challenge_name = stats['featured_challenge_name']
    @featured_challenge_prize = stats['featured_challenge_prize']
    @featured_challenge_details = stats['featured_challenge_details']
    
    @leaders = Challenges.get_leaderboard(current_access_token, :period => 'all')
    
    respond_to do |format|
      format.html
      format.json { render :json => @page }
    end
    
  end

end