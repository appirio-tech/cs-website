class QuizQuestionsController < ApplicationController
  before_filter :require_login
  
  def index
    @page_title = "Review Quick Quiz Questions"
    @results = QuickQuizes.review_questions(current_access_token, current_user.username)
    flash.now[:warning] = @results['message'] unless @results['records']
  end  
  
  def authored
    @questions = dbdc_client.query("select Id, Name, CreatedDate, Type__c, Reviewer_Notes__c, Status__c, Author_Paid__c from Quick_Quiz_Question__c where Author__r.Name = '#{current_user.username}' order by CreatedDate desc")
  end
  
  def reviewed
    @questions = dbdc_client.query("select Id, Name, CreatedDate, Type__c, Reviewer_Notes__c, Status__c, Reviewer_Paid__c from Quick_Quiz_Question__c where Reviewer__r.Name = '#{current_user.username}' order by CreatedDate desc")
  end
  
  def show
    @question = dbdc_client.query("select Id, Name, Author_Name__c, Reviewer__r.Name, Question__c, AnswerPrettyPrint__c, Reviewer_Notes__c from Quick_Quiz_Question__c where Id = '#{params[:id]}'").first
    if !@question.Author_Name__c.eql?(current_user.username) && !@question.Reviewer__r.Name.eql?(current_user.username) 
      render :inline => "You can only view questions that you either authored or reviewed."
    end
  end  
  
  def new
    @page_title = "Submit a Quick Quiz Question"
    @question = QuizQuestionForm.new()
  end
  
  def create
    @question = QuizQuestionForm.new(params[:quiz_question_form])
    if @question.valid?
      results = QuickQuizes.save_question(current_access_token, current_user.username, params[:quiz_question_form])
      if results
        flash[:notice] = "Your question was successfully submitted."
      else
        flash[:error] = "There was a problem submitting your questions. Please try again. Error: #{results['message']}"
      end
      redirect_to new_quiz_question_path
    else
      # show the error message
      render :action => 'new'
    end
  end
  
  def edit
    @page_title = "Review Quick Quiz Question"
    qqq = QuickQuizes.review_question(current_access_token, params[:id])
    @question = QuizQuestionForm.new({:id => qqq['Id'], :name => qqq['Name'], :question => qqq['Question__c'], :answer => qqq['AnswerPrettyPrint__c'], :type => qqq['Type__c'], 
      :author_comments => qqq['Author_Notes__c'], :reviewer_comments => qqq['Reviewer_Notes__c'] })
  end
  
  def update
    @question = QuizQuestionForm.new(params[:quiz_question_form])
    if @question.valid?
      results = QuickQuizes.update_question(current_access_token, current_user.username, params[:quiz_question_form])
      if results['success']
        flash[:notice] = "The question was successfully marked as #{params[:quiz_question_form]['status'].downcase}."
      else
        flash[:error] = "There was a problem updating your questions. Please try again. Error: #{results['message']}"
      end
      redirect_to quiz_questions_path
    else
      # show the error message
      render :action => 'edit'
    end
  end
  
  # if not signed in, then send them back to the challenge page
  def must_be_signed_in
    if !signed_in?
      flash[:error] = "Sorry... the page you were trying to access requires you to be logged in first."
      redirect_to challenge_path
    end
  end
  
  private
 
    def require_login
      unless logged_in?
        redirect_to login_required_url, :notice => 'You must be logged in to access this section.'
      end
    end
 
    def logged_in?
      !!current_user
    end
  
    def dbdc_client
      config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      client = Databasedotcom::Client.new(config)
      client.authenticate :username => current_user.sfdc_username, :password => current_user.password
      return client
    end  
  
end
