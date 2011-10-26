require 'will_paginate/array'

class MembersController < ApplicationController

  def index
    # Define the default order criteria
    order_by  = params[:order_by] || "name"

    @members = Members.all(:select => DEFAULT_MEMBER_FIELDS,:order_by => order_by)
    #
    # Sorting order hacked here cause not available in the CloudSpokes API
    if params[:order_by] == "total_wins__c" or params[:order_by] == "challenges_entered__c"
      @members = @members.reverse
    end
  end

  def show
    # Gather all required information for the page
    @member            = Members.all(:select => DEFAULT_MEMBER_FIELDS,:where => params[:id]).first

    @recommendations   = Recommendations.all(:select => DEFAULT_RECOMMENDATION_FIELDS,:where => @member["Name"])
    @challenges        = Members.challenges(:name => @member["Name"])

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
    @members = Members.all(:select => DEFAULT_MEMBER_FIELDS, :where => params[:query])
    render 'index'
  end

  # Need a merge of those 2 actions
  def past_challenges
    # NOTE: per_page is forced to 1
    @member = Members.find(params[:id])
    @challenges = Members.challenges(:name => @member["Name"]).select{|c| c["End_Date__c"].to_date < Time.now.to_date}
    @challenges = @challenges.paginate(:page => params[:page] || 1, :per_page => 1) 
    render 'challenges'
  end

  def active_challenges
    # NOTE: per_page is forced to 1
    @member = Members.find(params[:id])
    @challenges = Members.challenges(:name => @member["Name"]).select{|c| c["End_Date__c"].to_date > Time.now.to_date}
    @challenges = @challenges.paginate(:page => params[:page] || 1, :per_page => 1) 
    render 'challenges'
  end
end
