class CommunitiesController < ApplicationController
	before_filter :require_login

  def show

  	results = Communities.find_by_name(current_access_token, params[:community])
  	puts results
    @community = results['community']
    @challenges = results['challenges']
    @leaderboard = results['leaderboard']

		@leaderboard.sort! { |a,b| a['position'] <=> b['position'] }

  end

end
