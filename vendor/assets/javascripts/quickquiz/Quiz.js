function Quiz(data, components){

    var self = data;
    var editor = components.editor;
    var EDITOR_MIN_LINES = 20;
    var syntax = {'javascript': 'javascript', 'ruby':'ruby','java':'text/x-java', 'mixed':'text/html'};

    self.curr = ko.observable(0);
    self.language = ko.observable('');

    self.startTimer = function(){
        $(".stopwatch .start").click();
    };

    self.stopTimer = function(){
        $(".stopwatch .stop").click();
    };

    self.resetTimer = function(){
        $(".stopwatch .reset").click();
    };

    self.getTimerValue = function(){
        var time = [$(".stopwatch .display .hr").text(),
                    $(".stopwatch .display .min").text(),
                    $(".stopwatch .display .sec").text()].join(":");
        return time;
    };

    self.getTotalTime = function(){
        return $(".stopwatch .display .total").text();
    };

    self.loadQuestion = function(n){
	
		$.ajax({
		  type: 'GET',
		  url: data.url + '/quizes/' + data.challengeId + '/question.json?type=' + data.questionType,
		  success: successfulQuestion,
		  failire: failedQuestion
		});
		
		function failedQuestion(err) {
			console.log('Could not load question...' + err);		
		}		
		
		function successfulQuestion(returnData) {
	
			if (returnData.questionNbr == -1) {
				alert('Congratulations! You are done and your answers are being processed! Ready for your results?');
				window.location = data.url + '/quizes/'+data.challengeId+'/results';
			}

			// set the type and id to the data object
			data.question = returnData.question;
			
			// add the current question number
			$("#questionNbr").text(returnData.questionNbr);
			
	       	self.language(returnData.question.Type__c);
	        var lang = self.language().toLowerCase();
	        var question = returnData.question.Question__c.replace(/\+/g,' ');
			question = unescape(question);

	        editor.setOption("mode",syntax[lang]);
	        editor.setValue(question);

	        for(var i = (EDITOR_MIN_LINES - editor.lineCount()); i > 0; i--){
	            var lastLine = editor.lineCount() - 1;
	            editor.setLine(lastLine, editor.getLine(lastLine) + '\n');
	        }
	
	        self.startTimer();
		}
		
    };

	self.getAnswer = function(){
        return editor.getValue();
    };
	
	self.getMinifiedAnswer = function(){
        return editor.getValue().replace(/\s/g, "");
    };

    self.submit = function(){

        self.stopTimer();
		// data to post
		var dataString = 'question_id='+ data.question.Id + '&answer='+encodeURIComponent(self.getMinifiedAnswer());
		console.log(self.getMinifiedAnswer());
		
		// don't submit practice questions
		if (data.questionType.toLowerCase() != 'practice') {
		
			$.ajax({
			  type: 'POST',
			  url: data.url+'/quizes/'+data.challengeId+'/answer',
			  data: dataString
			});
		
		}

		// remove all text from the editor
		editor.setValue('');
		// remove the question number 
		$("#questionNbr").text('');
        self.resetTimer();
        self.loadQuestion();
    };

    self.loadQuestion();

    return self;
}