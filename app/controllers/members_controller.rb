require 'will_paginate/array'

class MembersController < ApplicationController
  before_filter :require_login, :only => [:recommend_new, :recommend]
  before_filter :redirect_to_http
  
  def redirect_to_http
    redirect_to url_for params.merge({:protocol => 'http://'}) unless !request.ssl?
  end

  def index
    @page_title = "Members and Top 10 Leaderboard"
    # Define the default order criteria
    order_by  = params[:order_by] || "total_wins__c"
    display_leaderboard  = params[:period] || "month"

    @members = Members.all(current_access_token, 
      :select => 'id,name,profile_pic__c,summary_bio__c,challenges_entered__c,challenges_submitted__c,active_challenges__c,total_wins__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c,total_money__c', 
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
      format.json { render :json => @members }
    end
  end

  def show
    # Gather all required information for the page
    @member = Members.find_by_username(current_access_token, params[:id], PUBLIC_MEMBER_FIELDS).first
    if @member.nil?
      render :file => "#{Rails.root}/public/member-not-found.html", :status => :not_found 
    else
      @page_title = "Member Profile: #{@member['Name']}"
      @recommendations   = Recommendations.all(current_access_token, :select => DEFAULT_RECOMMENDATION_FIELDS,:where => @member["Name"])
      @total_recommendations = @recommendations.size
      @recommendations = @recommendations.paginate(:page => params[:page] || 1, :per_page => 3) 
      @challenges = Members.challenges(current_access_token, :name => @member["Name"])
      @challenges = @challenges.reverse

      # Gather challenges and group them depending of their end date
      @active_challenges = []
      @past_challenges   = []
      
      @challenges.each do |challenge|        
        if !challenge['Challenge_Participants__r']['records'][0]['Status__c'].eql?('Watching') &&
          challenge['Challenge_Participants__r']['records'][0]['Score__c'] == 0 &&
          challenge['Challenge_Participants__r']['records'][0]['Has_Submission__c'] == true
          @active_challenges << challenge
        elsif challenge['Challenge_Participants__r']['records'].first['Has_Submission__c']
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
  end
  
  def past_challenges
    # Gather all required information for the page
    @member = Members.find_by_username(current_access_token, params[:id], DEFAULT_MEMBER_FIELDS).first
    if @member.nil?
      render :file => "#{Rails.root}/public/member-not-found.html", :status => :not_found 
    else
      @challenges = Members.challenges(current_access_token, :name => @member["Name"])
      @challenges = @challenges.reverse

      # Gather challenges and group them depending of their end date
      @past_challenges   = []
      @challenges.each do |challenge|
        if challenge["End_Date__c"].to_date < Time.now.to_date && challenge['Challenge_Participants__r']['records'].first['Has_Submission__c']
          @past_challenges << challenge
        end
      end
      respond_to do |format|
        format.html
        format.json { render :json => @past_challenges }
      end
    end
  end
  
  def active_challenges
    # Gather all required information for the page
    @member = Members.find_by_username(current_access_token, params[:id], DEFAULT_MEMBER_FIELDS).first
    if @member.nil?
      render :file => "#{Rails.root}/public/member-not-found.html", :status => :not_found 
    else
      @challenges = Members.challenges(current_access_token, :name => @member["Name"])
      @challenges = @challenges.reverse

      # Gather challenges and group them depending of their end date
      @active_challenges   = []
      @challenges.each do |challenge|
        if challenge["End_Date__c"].to_date > Time.now.to_date
          @active_challenges << challenge
        end
      end
      respond_to do |format|
        format.html
        format.json { render :json => @active_challenges }
      end
    end
  end

  def search
    @page_title = "Member Search Results"
    @members = Members.all(current_access_token, 
      :select => 'id,name,profile_pic__c,summary_bio__c,challenges_entered__c,challenges_submitted__c,total_wins__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c', 
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
    @member = Members.find_by_username(current_access_token, params[:id], DEFAULT_MEMBER_FIELDS).first
    if @member.nil?
      render :file => "#{Rails.root}/public/member-not-found.html", :status => :not_found 
    else
      @page_title = "Recommendation for #{@member['Name']}"
      flash.now[:error] = 'You cannot recomment yourself.' unless params[:id] != current_user.username
    end
  end
  
  def recommend_new
    results = Recommendations.save(current_access_token, params[:id], current_user.username, params[:recommendation][:comments])
    redirect_to member_path(params[:id])
  end
  
  private
 
    def require_login
      unless logged_in?
        flash[:error] = 'You must be logged in to access this page.'
        redirect_to login_required_url
      end
    end
 
    def logged_in?
      !!current_user
    end  

end
