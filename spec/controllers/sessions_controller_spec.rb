require 'spec_helper'

describe SessionsController do
  describe '#login_popup' do
    it 'sets a redirect after auth' do
      request.env['HTTP_REFERER'] = :referrer
      controller.stub!(:render)
      controller.login_popup
      session[:redirect_to_after_auth].should == :referrer
    end
  end

  describe '#destroy' do
    it 'redirects to root page after signing out' do
      controller.should_receive(:sign_out).once
      delete :destroy
      response.should be_redirect
    end
  end

end
