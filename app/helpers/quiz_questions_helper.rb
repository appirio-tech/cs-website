module QuizQuestionsHelper
  
  def question_type_options
    [["Please select ...",nil],["Java","Java"],["JavaScript","JavaScript"],["Ruby","Ruby"],["Python","Python"]]
  end
  
  def status_options
    [["Approved","Approved"],["Rejected","Rejected"]]
  end

end
