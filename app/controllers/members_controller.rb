require 'will_paginate/array'

class MembersController < ApplicationController

  def index
    # Define the default order criteria
    order_by  = params[:order_by] || "total_wins__c"
    display_leaderboard  = params[:period] || "month"

    @members = Members.all(current_access_token, 
      :select => 'id,name,profile_pic__c,summary_bio__c,challenges_entered__c,challenges_submitted__c,total_wins__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c,total_money__c', 
      :order_by => order_by)
      
    # Sorting order hacked here cause not available in the CloudSpokes API
    if order_by == "total_wins__c" or order_by == "challenges_entered__c"
      @members = @members.reverse
    end
    @members = @members.paginate(:page => params[:page] || 1, :per_page => 10) 
    
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    this_year = Time.new(tn.year)
    all_time = Time.new(2000)
    
    case display_leaderboard
    when "year"
      @leaderboard = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_year.iso8601(0),1)["data"])
    when "all"
      @leaderboard = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, all_time.iso8601(0),1)["data"])
    else
      @leaderboard = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_month.iso8601(0),1)["data"])
    end
    
  end

  def show
    # Gather all required information for the page
    @member            = Members.all(current_access_token, :select => DEFAULT_MEMBER_FIELDS,:where => params[:id]).first

    @recommendations   = Recommendations.all(current_access_token, :select => DEFAULT_RECOMMENDATION_FIELDS,:where => @member["Name"])
    @challenges        = Members.challenges(current_access_token, :name => @member["Name"])

    # Gather challenges and group them depending of their end date
    @active_challenges = []
    @past_challenges   = []
    @challenges.each do |challenge|
      if challenge["End_Date__c"].to_date > Time.now.to_date
        @active_challenges << challenge
      else
        @past_challenges << challenge
      end
    end
  end

  def search
    @members = Members.all(current_access_token, 
      :select => 'id,name,profile_pic__c,summary_bio__c,challenges_entered__c,challenges_submitted__c,total_wins__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c', 
      :where => params[:query])
    @members = @members.paginate(:page => params[:page] || 1, :per_page => 10)
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    @leaderboard = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_month.iso8601(0),1)["data"])   
    render 'index'
  end

  # Need a merge of those 2 actions
  def past_challenges
    # NOTE: per_page is forced to 1
    @member = Members.find(current_access_token, params[:id])
    @challenges = Members.challenges(current_access_token, :name => @member["Name"]).select{|c| c["End_Date__c"].to_date < Time.now.to_date}
    @challenges = @challenges.paginate(current_access_token, :page => params[:page] || 1, :per_page => 1) 
    render 'challenges'
  end

  def active_challenges
    # NOTE: per_page is forced to 1
    @member = Members.find(current_access_token, params[:id])
    @challenges = Members.challenges(current_access_token, :name => @member["Name"]).select{|c| c["End_Date__c"].to_date > Time.now.to_date}
    @challenges = @challenges.paginate(current_access_token, :page => params[:page] || 1, :per_page => 1) 
    render 'challenges'
  end
end
