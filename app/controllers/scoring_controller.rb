require 'scoring'

class ScoringController < ApplicationController
  before_filter :require_login
  
  def index
    @challenges = Scoring.outstanding_scorecards(current_access_token)
    puts @challenges
    p request.host
  end

  #fetches the scorecard the participant and current user who is the reviewer
  def scorecard
    scorecard = Scoring.scorecard(current_access_token, params[:id], current_user.username).to_json
    # get the 'message' potion of the string
    message = scorecard[0,scorecard.index('[')].gsub('\\','')
    # see if the scorecard has been scored
    @scored = message.index('"scored__c": "true"').nil? ? false : true
    # set the json results to be html safe are usable in the javascript
    @json = scorecard[scorecard.index('['),scorecard.length].gsub(']}',']').html_safe
  end
  
  def save
    save_results = Scoring.save_scorecard(current_access_token, params[:xml],params[:set_as_scored])
    if save_results[:success].eql?('true')
      redirect_to scoring_url
    else
      flash[:error] = save_results[:message]
      redirect_to(:back)
    end
  end
  
  private
 
    def require_login
      unless logged_in?
        redirect_to login_url, :notice => 'You must be logged in to access this section'
      end
    end
 
    def logged_in?
      !!current_user
    end

end
