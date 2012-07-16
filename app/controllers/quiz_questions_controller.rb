require 'sfdc_connection'

class QuizQuestionsController < ApplicationController
  before_filter :require_login
  before_filter :redirect_to_http
  
  def index
    @page_title = "Review Quick Quiz Questions"
    @results = QuickQuizes.review_questions(current_access_token, current_user.username)
    flash.now[:warning] = @results['message'] unless @results['records']
  end  
  
  def authored
    @questions = SfdcConnection.admin_dbdc_client.query("select Id, Name, CreatedDate, Type__c, Reviewer_Notes__c, Status__c, Author_Paid__c from Quick_Quiz_Question__c where Author__r.Name = '#{current_user.username}' order by CreatedDate desc")
  end
  
  def reviewed
    @questions = SfdcConnection.admin_dbdc_client.query("select Id, Name, CreatedDate, Type__c, Reviewer_Notes__c, Status__c, Reviewer_Paid__c from Quick_Quiz_Question__c where Reviewer__r.Name = '#{current_user.username}' order by CreatedDate desc")
  end
  
  def show
    @question = SfdcConnection.admin_dbdc_client.query("select Id, Name, Author_Name__c, Reviewer__r.Name, Question__c, AnswerPrettyPrint__c, Reviewer_Notes__c from Quick_Quiz_Question__c where Id = '#{params[:id]}'").first
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
    @question = QuizQuestionForm.new({:id => qqq['Id'], :name => qqq['Name'], :question => qqq['Question__c'], 
      :answer => qqq['AnswerPrettyPrint__c'], :type => qqq['Type__c'], :author_comments => qqq['Author_Notes__c'], 
      :reviewer_comments => qqq['Reviewer_Notes__c'], :flagged_comments => qqq['Flagged_Comments__c'] })
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
  
end
