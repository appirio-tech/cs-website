require 'sfdc_connection'
require 'cs_api_stats'
require 'base64'
require 'cgi'
require 'openssl'
require 'js_connect'

class ContentController < ApplicationController
  before_filter :redirect_to_http

  def forums

    user = {name: '', photourl: ''}
    if current_user
      user = {email: current_user.email, name: current_user.username, 
          photourl: current_user.profile_pic,
          uniqueid: current_user.username}
    end  
    user.merge!({client_id: ENV['VANILLA_CLIENT_ID']})    

    # Start with the signed in user and add in the client_id
    # user = {email: 'jeff+snippets@jeffdouglas.com', name: 'jeffdonthemic-snippets', 
    #     photourl: 'http://lh4.ggpht.com/4wzpuaY9Oz1uNSyjinB72Re8V3DMEEyaeaLzJegV_tHyDYZm2nrNq6E_LuICWFs0-r-E70LgxlHca4qKxXKCSaP2zjarwgg',
    #     uniqueid: 'jeffdonthemic-snippets', 
    #     client_id: ENV['VANILLA_CLIENT_ID']}

    # json encode the user
    json = ActiveSupport::JSON.encode(user);     
    # base 64 encode the user json
    signature_string = Base64.strict_encode64(json)
    # Sign the signature string with signature and the current timestamp using hmac sha1 (use vanilla secret as the key??)
    signature = Digest::HMAC.hexdigest(signature_string + ' ' +  Time.now.to_i.to_s, ENV['VANILLA_SECRET'], Digest::SHA1)
    # build the final sso string
    @vanilla_sso = "#{signature_string} #{signature} #{Time.now.to_i} hmacsha1"

  end

  def forums_authenticate 

    user = {name: '', photourl: ''}
    if current_user
      user = {email: current_user.email, name: current_user.username, 
          photourl: current_user.profile_pic,
          uniqueid: current_user.username}
    end    

    # user = {email: 'jeff+snippets@jeffdouglas.com', name: 'jeffdonthemic-snippets', 
    #     photourl: 'http://lh4.ggpht.com/4wzpuaY9Oz1uNSyjinB72Re8V3DMEEyaeaLzJegV_tHyDYZm2nrNq6E_LuICWFs0-r-E70LgxlHca4qKxXKCSaP2zjarwgg',
    #     uniqueid: 'jeffdonthemic-snippets'}

    render :json => JsConnect::getJsConnectString(user, request, ENV['VANILLA_CLIENT_ID'], ENV['VANILLA_SECRET']) 

  end

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