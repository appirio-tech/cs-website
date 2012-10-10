require 'will_paginate/array'
require 'cs_api_member'

class MembersController < ApplicationController
  before_filter :require_login, :only => [:recommend_new, :recommend]
  before_filter :redirect_to_http
  before_filter :check_if_member_exists, :only => [:show, :active_challenges, :past_challenges, :recommend]

  def index
    @page_title = "Members and Top 10 Leaderboard"
    # Define the default order criteria
    order_by = params[:order_by] || "total_wins"
    if order_by == "total_wins" or order_by == "challenges_entered"
      order_by = "#{order_by} desc"
    end
    display_leaderboard  = params[:period] || "month"

    @members = CsApi::Member.all(current_access_token, PRETTY_MEMBER_SEARCH_FIELDS, order_by)
    @members = @members.paginate(:page => params[:page] || 1, :per_page => 10) 
    
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    this_year = Time.new(tn.year)
    all_time = Time.new(2000)
    @selected = {'month'=>'', 'year'=>'', 'all'=>'' }
    
    case display_leaderboard
    when "year"
      @selected['year'] = 'active'
      @leaderboard = Challenges.get_leaderboard(current_access_token, :period => 'year')
    when "all"
      @selected['all'] = 'active'
      @leaderboard = Challenges.get_leaderboard(current_access_token)
    else
      @selected['month'] = 'active'
      @leaderboard = Challenges.get_leaderboard(current_access_token, :period => 'month')
    end
    respond_to do |format|
      format.html
      format.json { render :json => @leaderboard }
    end
  end

  def show
    # Gather all required information for the page
    @member = requested_member
    @page_title = "Member Profile: #{@member['Name']}"
    @recommendations   = CsApi::Member.recommendations(current_access_token, params[:id])
    @total_recommendations = @recommendations.size
    @recommendations = @recommendations.paginate(:page => params[:page] || 1, :per_page => 3) 
    @challenges = CsApi::Member.challenges(current_access_token, params[:id])
    @challenges = @challenges.reverse

    # Gather challenges and group them depending of their end date
    @active_challenges = []
    @past_challenges   = []
    
    @challenges.each do |challenge|        
      if !challenge['challenge_participants__r']['records'][0]['status'].eql?('Watching') &&
        ACTIVE_CHALLENGE_STATUSES.include?(challenge['status'])
        @active_challenges << challenge
      elsif challenge['challenge_participants__r']['records'].first['has_submission']
        @past_challenges << challenge
      end
    end
    respond_to do |format|
      format.html
      format.json { 
        @member[:active_challenges] = @active_challenges
        @member[:past_challenges] = @past_challenges
        render :json => @member 
      }
    end
  end 
  
  def past_challenges
    @member = requested_member
    @challenges = CsApi::Member.challenges(current_access_token, params[:id])
    @challenges = @challenges.reverse

    # Gather challenges and group them depending of their end date
    @past_challenges   = []
    @challenges.each do |challenge|
      unless ACTIVE_CHALLENGE_STATUSES.include?(challenge['status'])
        @past_challenges << challenge if challenge['challenge_participants__r']['records'].first['has_submission']
      end
    end
    respond_to do |format|
      format.html
      format.json { render :json => @past_challenges }
    end
  end
  
  def active_challenges
    @member = requested_member
    @challenges = CsApi::Member.challenges(current_access_token, params[:id])
    @challenges = @challenges.reverse

    # Gather challenges and group them depending of their end date
    @active_challenges   = []
    @challenges.each do |challenge|
      if !challenge['challenge_participants__r']['records'][0]['status'].eql?('Watching') && 
        ACTIVE_CHALLENGE_STATUSES.include?(challenge['status'])
        @active_challenges << challenge
      end
    end
    respond_to do |format|
      format.html
      format.json { render :json => @active_challenges }
    end
  end

  def search
    @page_title = "Member Search Results"
    @members = Members.all(current_access_token, 
      :select => MEMBER_SEARCH_FIELDS, 
      :where => params[:keyword])
    @members = @members.paginate(:page => params[:page] || 1, :per_page => 10)
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
		@selected = {'month'=>'', 'year'=>'', 'all'=>'' }
		# By default displaying leaderboard month wise
		@leaderboard = Challenges.get_leaderboard(current_access_token, :period => 'month', :category => params[:category] || nil)		
		@selected['month'] = 'active'
    respond_to do |format|
      format.html { render 'index' }
      format.json { render :json => @members }
    end
  end
  
  def recommend
    @member = requested_member
    @page_title = "Recommendation for #{@member['Name']}"
    flash.now[:error] = 'You cannot recommend yourself.' unless params[:id] != current_user.username
  end
  
  def recommend_new
    results = CsApi::Member.recommend(current_access_token, params[:id], current_user.username, 
      params[:recommendation][:comments]) unless params[:recommendation][:comments].empty?
    redirect_to member_path(params[:id])
  end

  def requested_member
    @member ||= CsApi::Member.find_by_membername(current_access_token, params[:id], PRETTY_PUBLIC_MEMBER_FIELDS)
  end

  def check_if_member_exists
    render :file => "#{Rails.root}/public/member-not-found.html", :status => :not_found if requested_member.nil?
  end

end
