require 'challenges'

class ChallengesController < ApplicationController
  
  def index
    @challenges = Challenges.get_challenges(current_access_token)
    puts @challenges
  end

end