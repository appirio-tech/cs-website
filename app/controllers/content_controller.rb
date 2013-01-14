require 'sfdc_connection'
require 'cs_api_stats'
require 'base64'
require 'cgi'
require 'openssl'

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
    user = {email: 'jdouglas@appirio.com', name: 'jeff douglas', 
        photourl: 'http://www.cloudspokes.com/some-image.png',
        uniqueid: 'jeffdonthemic', 
        client_id: client_id}.to_json
     
    # base64 encode the user with the time stamp
    signature_string = "#{Base64.encode64(user)} #{Time.now}"
    # sign the signature string
    signature = CGI.escape("#{OpenSSL::HMAC.digest('sha1', secret, signature_string)}")
    # build the final sso string
    @vanilla_sso = "#{signature_string} #{signature} #{Time.now} hmacsha1"

  end

  def forums_authenticate 

    client_id = '1048311983'
    secret = 'ac9be007d9819ace8d687405b3139a47'

    user = {email: 'jdouglas@appirio.com', name: 'jeff douglas', 
        photourl: 'http://www.cloudspokes.com/some-image.png',
        uniqueid: 'jeffdonthemic'}

    # Url encode the sorted user
    signature_string = user.to_param

    # sign the signature_string with the secret. no base64 encoding?
    signature = CGI.escape("#{OpenSSL::HMAC.digest('sha1', secret, signature_string)}") 

    # add the client_id and signature to the user
    user.merge!({client_id: client_id, signature: signature})

    #render as json
    render :json => "callback(#{user.to_json})"  
  end

end