require 'spec_helper'

describe SessionsController do
  let (:user) { stub_model(User, :id => 1, :username => 'kerdosa', :password => "kerdosa01", :sfdc_username => "sfdc_kerdosa",
                              :email => 'kerdosa@cs.com')}
  let(:settings) { stub_model(Settings, :auth_token => "123456")}
  
  describe "login_popup, login" do
    it "should be successful in login_popup" do
      get :login_popup
      response.should be_success
      response.should render_template('login_popup')
    end
    
    it "should be successful and render login template" do
      get :login
      response.should be_success
      response.should render_template('login')
    end

  end
  
  describe "login_cs_auth" do
    describe "successful/failed login" do

      before(:each) do
        @valid_login_form = { :username => user.username, :password => user.password }
        Utils.stub(:public_access_token).and_return(settings.auth_token)
        message = '{"Message" : "activated_message"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/activate.*/).to_return(:body => message, :status => 200)
      end
      
      it "should login with valid credential" do
        User.should_receive(:authenticate).with(user.username, user.password).and_return(user)
                
        post :login_cs_auth, :login_form => @valid_login_form
        message_verifier = ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token)
        signed_remember_token = message_verifier.generate([user.id])
        cookies[:remember_token].should == signed_remember_token
        
        # Unfortunately cookies.signed is not available in test
        # User.should_receive(:authenticate_with_salt).and_return(user)
        # controller.current_user.should == user
        response.should redirect_to(challenges_path)
      end
      
      it "should fail to login with invalid password" do
        User.should_receive(:authenticate).with(user.username, 'wrong').and_return(nil)
        post :login_cs_auth, :login_form => {:username => user.username, :password => 'wrong'}
        cookies[:remember_token].should be_nil
        flash.now[:error].should == "Invalid email/password."
        response.should render_template('login')
      end

      it "should fail to login with invalid login_form" do
        post :login_cs_auth, :login_form => {:username => user.username}
        cookies[:remember_token].should be_nil
        response.should render_template('login')
      end
    end
  end
  
  describe "delete destroy" do
    it "should destroy remember_token" do
      # controller.current_user = user
      cookies[:remember_token] = user.id
      get :destroy
      # controller.current_user.should be_nil
      cookies[:remember_token].should be_nil
      response.should redirect_to(root_path)
    end
  end
  
  describe "signup" do
    before(:each) do
      Utils.stub(:public_access_token).and_return(settings.auth_token)
    end

    it "should be successful in signup" do
      get :signup
      response.should be_success
      response.should render_template('signup')
    end
    
    context "signup_cs_create" do
      before(:each) do
        @signup_form = { :username => user.username, :email => 'kerdosa@gmail.com', :password => user.password, 
                          :password_confirmation => user.password }
      end
      
      it "should success and redirect to challenges_path" do
        message = '{"Success" : "true", "username" : "kerdosa", "sfdc_username" : "kerdosa", "Message" : "Welcome new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(true)
        post :signup_cs_create, :signup_form => @signup_form
        message_verifier = ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token)
        signed_remember_token = message_verifier.generate([user.id])
        cookies[:remember_token].should == signed_remember_token
        response.should redirect_to(challenges_path)
      end

      it "should render sigup on save failure" do
        message = '{"Success" : "true", "username" : "kerdosa", "sfdc_username" : "sfdc_kerdosa", "Message" : "Welcome new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(false)
        post :signup_cs_create, :signup_form => @signup_form
        flash.now[:error].should_not be_nil
        cookies[:remember_token].should be_nil
        response.should render_template('signup')
      end

      it "should render sigup on SFDC REST failure" do
        message = '{"Success" : "false", "username" : "kerdosa", "sfdc_username" : "kerdosa", "Message" : "REST failed"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        post :signup_cs_create, :signup_form => @signup_form
        flash.now[:error].should_not be_nil
        flash.now[:error].should == 'REST failed'
        cookies[:remember_token].should be_nil
        response.should render_template('signup')
      end

      it "should render sigup on invalid signup form" do
        @invalid_signup_form = { :username => user.username, :password => user.password }
        post :signup_cs_create, :signup_form => @invalid_signup_form
        cookies[:remember_token].should be_nil
        response.should render_template('signup')
      end
    end
    
    context "signup_complete" do
      before(:each) do
        @signup_complete_form = { :username => user.username, :email => 'kerdosa@gmail.com', :name => 'kerdosa',
                  :uid => user.id, :provider => 'twitter'}
      end
      
      it "should success in signup with valid signup_complete_form" do
        session[:redirect_to_after_auth] = root_url
        message = '{"Success" : "true", "username" : "kerdosa", "sfdc_username" : "kerdosa", "Message" : "Welcome new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(true)
        post :signup_complete, :signup_complete_form => @signup_complete_form
        session[:blank_username].should be_nil
        cookies[:remember_token].should_not be_nil
        response.should redirect_to(root_url)
      end

      it "should render inline on user save failure" do
        message = '{"Success" : "true", "username" : "kerdosa", "sfdc_username" : "kerdosa", "Message" : "Welcome new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(false)
        post :signup_complete, :signup_complete_form => @signup_complete_form
        cookies[:remember_token].should be_nil
        response.should be_success
        response.body.should =~ /Whoops! An error occured/
      end

      it "should flash error on new member create failure" do
        message = '{"Success" : "false", "username" : "kerdosa", "sfdc_username" : "kerdosa", "Message" : "REST failed"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => message, :status => 200)
        post :signup_complete, :signup_complete_form => @signup_complete_form
        cookies[:remember_token].should be_nil
        flash.now[:error].should_not be_nil
        response.should be_success
      end

      it "should delete authsession on no signup_complete_form" do
        authhash = {'info' => {'nickname' => user.username}}
        session[:authsession] = AuthSession.new(authhash, '')
        post :signup_complete
        session[:authsession].should be_nil
      end

      it "should delete authsession on no signup_complete_form with blank username" do
        authhash = {'info' => {'name' => user.username}}
        session[:authsession] = AuthSession.new(authhash, '')
        post :signup_complete
        session[:blank_username].should be_true
        session[:authsession].should be_nil
      end
    end
  end
  
  describe "oath" do
    before(:each) do
      @valid_login_form = { :username => user.username, :password => user.password }
      Utils.stub(:public_access_token).and_return(settings.auth_token)
      session[:redirect_to_after_auth] = root_url
    end
    
    context "oauth callbadk" do
      it "should success and redirect to redirect_to_after_auth" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "true", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "Credential is valid"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        activated_message = '{"Message" : "activated_message"}'
        stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/activate.*/).to_return(:body => activated_message, :status => 200)
        User.should_receive(:authenticate_third_party).and_return(user)        
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should_not be_nil
        response.should redirect_to(root_url)
      end

      it "should have flash error on authentication fail" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "true", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "Credential is valid"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        activated_message = '{"Message" : "activated_message"}'
        stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/activate.*/).to_return(:body => activated_message, :status => 200)
        User.should_receive(:authenticate_third_party).and_return(nil)
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should be_nil
        flash[:error].should_not be_nil
        # response.should be_success
        response.should redirect_to(login_url)
      end

      it "should render inline on session expire" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "Session expired or invalid"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should be_nil
        response.body.should =~ /Whoops! An error occured/
        response.should be_success
      end

      it "should redirect to singup_complete_url when username or email is empty" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username}}
        message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "email is empty"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should be_nil
        session[:authsession].get_hash[:username].should == request.env['omniauth.auth']['info']['nickname']
        response.should redirect_to(signup_complete_url)
      end

      it "should success on new member" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "new member"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        member_message = '{"Success" : "true", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => member_message, :status => 200)
        User.should_receive(:find_by_username).and_return(user)
        User.should_receive(:delete).and_return(nil)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(true)
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should_not be_nil
        response.should redirect_to(root_url)
      end

      it "should render inline error message on failing to save user" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "new member"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        member_message = '{"Success" : "true", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => member_message, :status => 200)
        User.should_receive(:find_by_username).and_return(user)
        User.should_receive(:delete).and_return(nil)
        User.should_receive(:new).and_return(user)
        user.should_receive(:save).and_return(false)
        errors = ActiveModel::Errors.new(user)
        errors.add(:error_messages, "save failed")
        user.should_receive(:errors).twice.and_return(errors)
        get :callback, :provider => 'twitter'
        cookies[:remember_token].should be_nil
        response.body.should =~ /save failed/
        response.should be_success
      end

      it "should redirect to login_url on failing to create new_member" do
        request.env['omniauth.auth'] = {'info' => {'nickname' => user.username, 'email' => user.email}}
        message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "new member"}'
        stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/credentials/).to_return(:body => message, :status => 200)
        member_message = '{"Success" : "false", "Username" : "kerdosa", "SFusername" : "sf_kerdosa", "Message" : "failed to create new member"}'
        stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/members/).to_return(:body => member_message, :status => 200)
        get :callback, :provider => 'twitter'
        flash[:error].should =~ /failed to create new member/
        cookies[:remember_token].should be_nil
        response.should redirect_to(login_url)
      end      
    end
    
    it "should redirect to root in callback_failure" do
      get :callback_failure
      response.should redirect_to(root_url)
    end
  end
  
  describe "public_forgot_* " do
    before(:each) do
      Utils.stub(:public_access_token).and_return(settings.auth_token)
    end
    
    it "should be successful in forgot_service" do
      message = '[{"Login_Managed_By__c" : "login_managed_by__c"}]'
      stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/members.*/).to_return(:body => message, :status => 200)
      get :forgot_service, :form_forgot_service => {:username => 'mess'}
      response.should be_success
      response.should render_template('forgot_service')
    end

    it "should be flash error without data" do
      # message = '{"Login_Managed_By__c" : "login_managed_by__c"}'
      stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/members.*/).to_return(:body => '[]', :status => 200)
      get :forgot_service, :form_forgot_service => {:username => 'mess'}
      response.should be_success
      flash.now[:error].should =~ /Could not find a member/
      response.should render_template('forgot_service')
    end

    it "should be flash error without username" do
      get :forgot_service, :form_forgot_service => {:username => ''}
      response.should be_success
      flash.now[:error].should =~ /Please enter a CloudSpokes username/
      response.should render_template('forgot_service')
    end
    
    it "should redirect to reset_password_url in public_forgot_password_send" do
      message = '{"Success" : "true", "Message": "password was reset"}'
      stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/password.*/).to_return(:body => message, :status => 200)
      get :public_forgot_password_send, :form_forgot_password => {:username => 'mess'}
      # flash[:notice].should_not be_nil
      flash[:notice].should =~ /password was reset/
      response.should redirect_to(reset_password_url)
    end

    it "should redirect to forgot_password_url in public_forgot_password_send with failure" do
      message = '{"Success" : "false", "Message": "password rest failed"}'
      stub_request(:post, /#{ENV['SFDC_REST_API_URL']}\/password.*/).to_return(:body => message, :status => 200)
      get :public_forgot_password_send, :form_forgot_password => {:username => 'mess'}
      # flash[:error].should_not be_nil
      flash[:error].should =~ /password rest failed/
      response.should redirect_to(forgot_password_url)
    end

    it "should be successful in public_reset_password" do
      get :public_reset_password
      response.should be_success
      response.should render_template('public_reset_password')
    end
    
    it "should be successful with valid form in public_reset_password_submit" do
      message = '{"Success" : "true", "Message": "password was reset"}'
      stub_request(:put, /#{ENV['SFDC_REST_API_URL']}\/password.*/).to_return(:body => message, :status => 200)
      valid_reset_password_form = { :username => user.username, :password => user.password, :passcode => "passcode" }
      post :public_reset_password_submit, :reset_password_form => valid_reset_password_form
      response.should be_success
      flash.now[:warning].should == "password was reset"
      response.should render_template('public_reset_password')
    end

    it "should be successful with not-valid form in public_reset_password_submit" do
      message = '{"Success" : "true", "Message": "password was reset"}'
      stub_request(:put, /#{ENV['SFDC_REST_API_URL']}\/password.*/).to_return(:body => message, :status => 200)
      invalid_reset_password_form = { :username => user.username, :password => user.password }
      post :public_reset_password_submit, :reset_password_form => invalid_reset_password_form
      response.should be_success
      response.should render_template('public_reset_password')
    end
  end
  
end
