class CommunitiesController < ApplicationController
	before_filter :require_login
  before_filter :check_if_community_exists

  def show

  	results = requested_community
    @community = results['community']
    @challenges = results['challenges']
    @leaderboard = results['leaderboard']
    # sort the leaders by position
		@leaderboard.sort! { |a,b| a['position'] <=> b['position'] }

  end

  def requested_community
    community ||= Communities.find_by_name(current_access_token, params[:community])
  end  

  def check_if_community_exists
    community = requested_community
    render :file => "#{Rails.root}/public/404.html", :status => :not_found if community.nil?
  end

end
