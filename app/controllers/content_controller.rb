require 'sfdc_connection'
require 'cs_api_stats'
require 'base64'
require 'cgi'
require 'openssl'
require 'js_connect'

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

  def forums

    client_id = '1048311983'
    secret = 'ac9be007d9819ace8d687405b3139a47'

    #create the signed user as json
    user = {email: 'jdouglas@appirio.com', name: 'jeffdonthemic', 
        photourl: 'http://lh4.ggpht.com/4wzpuaY9Oz1uNSyjinB72Re8V3DMEEyaeaLzJegV_tHyDYZm2nrNq6E_LuICWFs0-r-E70LgxlHca4qKxXKCSaP2zjarwgg',
        uniqueid: 'jeffdonthemic', 
        client_id: client_id}.to_json
     
    # base64 encode the user with the time stamp
    signature_string = "#{Base64.encode64(user)} #{Time.now.to_i}"
    # sign the signature string
    signature = CGI.escape("#{OpenSSL::HMAC.digest('sha1', secret, signature_string)}")
    # build the final sso string
    @vanilla_sso = "#{signature_string} #{signature} #{Time.now.to_i} hmacsha1"

  end

  def forums_authenticate 

    client_id = '1048311983'
    secret = 'ac9be007d9819ace8d687405b3139a47'

    user = {'email' => 'jdouglas@appirio.com', 'name' => 'jeffdonthemic', 
        'photourl' => 'http://lh4.ggpht.com/4wzpuaY9Oz1uNSyjinB72Re8V3DMEEyaeaLzJegV_tHyDYZm2nrNq6E_LuICWFs0-r-E70LgxlHca4qKxXKCSaP2zjarwgg',
        'uniqueid' => 'jeffdonthemic'}

    callback = JsConnect::getJsConnectString(user, request, client_id, secret)

    #render as json
    render :json => callback 
  end

end