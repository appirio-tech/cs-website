class ErrorsController < ApplicationController
  def routing
    if params.has_key?('contestID') 
      redirect_to "/challenges/#{params['contestID']}"
    elsif params.has_key?('ContestID')
      redirect_to "/challenges/#{params['ContestID']}"
    elsif params.has_key?('username')
      redirect_to "/members/#{params['username']}"
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end