require 'cloud_spokes'

class Surveys < Cloudspokes
  
  def self.save_post_challenge(access_token, id, params)
    
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

  def self.save_pre_challenge(access_token, id, params)
    
    options = {
      :body => {
          :challenge => id,
          :membername => params[:membername],
          :requirements => params[:requirements],
          :requirements_feedback => params[:requirements_feedback],
          :timeframe => params[:timeframe],
          :prize_money => params[:prize_money],
          :participation => params[:participation],
          :improvements => params[:improvements]
      }
    }
    
    post(ENV['SFDC_REST_API_URL']+'/preview-surveys', options)
  end  

end

