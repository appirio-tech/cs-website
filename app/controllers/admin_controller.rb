class AdminController < ApplicationController

  before_filter :authenticate
  
  def blogfodder
    @challenge = Challenges.find_by_id(current_access_token, params[:id])[0]
    @winners = Challenges.winners(current_access_token, params[:id])
    @all_submissions = Challenges.all_submissions(current_access_token, params[:id])
  end
    
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['WEB_ADMIN_USERNAME'] && password == ENV['WEB_ADMIN_PASSWORD']
    end
  end

end
