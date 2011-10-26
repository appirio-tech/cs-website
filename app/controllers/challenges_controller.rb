require 'challenges'
require 'time'
require 'settings'

class ChallengesController < ApplicationController

  def index  
        
    show_open = false
    show_open = true unless params[:show].eql?('closed')
    orderby = params[:orderby].nil? ? 'name' : params[:orderby]
    
    p "show open: #{show_open}"
    p "orderby: #{orderby}"
    
    if params[:keyword].nil?
      @challenges = Challenges.get_challenges(current_access_token, show_open, orderby, params[:category])
    else 
      @challenges = Challenges.get_challenges_by_keyword(current_access_token, params[:keyword])
    end
    
  end
  
  def detail
    @challenge_detail = Challenges.get_challenge_detail(current_access_token, params[:id])[0]
    @prizes = Challenges.get_prizes(current_access_token, params[:id])
    @categories = Challenges.get_categories(current_access_token, params[:id])
    end_time = Time.parse(@challenge_detail["End_Date__c"])
    if end_time.past?
        @challenge_detail["TimeTillEnd"] = "Completed"
    else
        secs = Time.parse(@challenge_detail["End_Date__c"]) - Time.now
        @challenge_detail["TimeTillEnd"] = "due in "
        @challenge_detail["TimeTillEnd"] += (secs/86400).floor.to_s + " day(s) "
        secs = secs%86400
        @challenge_detail["TimeTillEnd"] += (secs/3600).floor.to_s + " hour(s) " + ((secs%3600)/60).round.to_s + " minute(s)"
    end
    @prizes.sort {|x,y| y["Place__c"] <=> x["Place__c"]}
  end
  
  def registrants
    @challenge_detail = Challenges.get_challenge_detail(current_access_token, params[:id])[0]
    @registrants = Challenges.get_registrants(current_access_token, params[:id])
    @prizes = Challenges.get_prizes(current_access_token, params[:id])
    @prizes.sort {|x,y| y["Place__c"] <=> x["Place__c"]}
    end_time = Time.parse(@challenge_detail["End_Date__c"])
    if end_time.past?
        @challenge_detail["TimeTillEnd"] = "Completed"
    else
        secs = Time.parse(@challenge_detail["End_Date__c"]) - Time.now
        @challenge_detail["TimeTillEnd"] = "due in "
        @challenge_detail["TimeTillEnd"] += (secs/86400).floor.to_s + " day(s) "
        secs = secs%86400
        @challenge_detail["TimeTillEnd"] += (secs/3600).floor.to_s + " hour(s) " + ((secs%3600)/60).round.to_s + " minute(s)"
    end
    puts @registrants
  end
  
  def leaderboard
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    this_year = Time.new(tn.year)
    all_time = Time.new(2000)
    @this_month_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_month.iso8601(0),1)["data"])
    @this_year_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_year.iso8601(0),1)["data"])
    @all_time_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, all_time.iso8601(0),1)["data"])
  end
end
