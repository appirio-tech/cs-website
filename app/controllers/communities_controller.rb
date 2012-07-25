class CommunitiesController < ApplicationController

  def show

  	client = SfdcConnection.admin_dbdc_client
  	community_class = client.materialize("Community__c")
  	communities = Community__c.find_by_Name(params[:community])
  	puts communities

  end

end
