require 'sfdc_connection'

class ContentController < ApplicationController
  before_filter :redirect_to_http
  
  def home
    @page_title = "A unique cloud development community, focused on mobile technologies and public cloud platforms."

    client = Savon.client(ENV['STATS_WSDL_URL'])
    response = client.request(:stat, :platform_stats) do
      soap.namespaces["xmlns:stat"] = "http://soap.sforce.com/schemas/class/StatsWS"
      soap.header = { 'stat:SessionHeader' => { 'stat:sessionId' => current_access_token }}
    end 
    @page = response.to_array(:platform_stats_response, :result).first
    @featured_member_username = @page[:featured_member_username]
    @featured_member_pic = @page[:featured_member_pic]
    @featured_member_money = @page[:featured_member_money]
    @featured_member_active = @page[:featured_member_active]
    @featured_member_wins = @page[:featured_member_wins]
    
    @members = @page[:members]
    @challenes_open = @page[:challenes_open]
    @chalenges_won = @page[:chalenges_won]
    @money_up_for_grabs = @page[:money_up_for_grabs]
    @money_pending = @page[:money_pending]
    @entries_submitted = @page[:entries_submitted]
    
    @featured_challenge_id = @page[:featured_challenge_id]
    @featured_challenge_name = @page[:featured_challenge_name]
    @featured_challenge_prize = @page[:featured_challenge_prize]
    @featured_challenge_details = @page[:featured_challenge_details]
    
    @leaders = Challenges.get_leaderboard(current_access_token, :period => 'all')
    
    respond_to do |format|
      format.html
      format.json { render :json => @page }
    end
    
  end

end