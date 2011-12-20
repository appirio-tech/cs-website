class ErrorsController < ApplicationController
  def routing
    if params.has_key?('contestID') 
      id = Challenges.find_by_sql_id(current_access_token, params['contestID']).first
      redirect_to "/challenges/#{id}"
    elsif params.has_key?('ContestID')
      id = Challenges.find_by_sql_id(current_access_token, params['ContestID']).first
      redirect_to "/challenges/#{id}"
    elsif params.has_key?('username')
      redirect_to "/members/#{params['username']}"
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end