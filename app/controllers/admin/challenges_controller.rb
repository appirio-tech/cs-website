require 'cs_api_account'
require 'cs_api_member'
require 'will_paginate/array'

class Admin::ChallengesController < ApplicationController
	layout 'admin'

  def new
    @challenge = Admin::Challenge.new
    # defaulted to the current time so that the user can make changes if desired
    @challenge.start_date = Time.now.ctime
    @prizes = []
  end  

  def edit
  	@challenge = Challenges.find_by_id(current_access_token, params[:id])[0]
  end

end