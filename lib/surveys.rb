require 'cloud_spokes'

class Surveys < Cloudspokes
  
  def self.save(access_token, id, params)
    
    options = {
      :body => {
          :challenge => id,
          :compete_again => params[:compete_again],
          :prize_money => params[:prize_money],
          :requirements => params[:requirements],
          :timeframe => params[:timeframe],
          :why_no_submission => params[:why_no_submission],
          :improvements => params[:improvements]
      }
    }
    
    results = post(ENV['SFDC_REST_API_URL']+'/surveys', options)
  end

end

