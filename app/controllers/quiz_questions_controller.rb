class QuizQuestionsController < ApplicationController
  
  def index
    @page_title = "Review Quick Quiz Questions"
    @results = QuickQuizes.review_questions(current_access_token, current_user.username)
    flash.now[:warning] = @results['message'] unless @results['records']
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
  
end
