function Quiz(data, components){

    var self = data;
    var editor = components.editor;
    var EDITOR_MIN_LINES = 20;
    var syntax = {'javascript': 'javascript', 'ruby':'ruby','java':'text/x-java', 'mixed':'text/html'};

    self.curr = ko.observable(0);
    self.language = ko.observable('');

    console.log(data);

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

        if(self.curr() === self.records.length){
            window.location = 'http://www.cloudspokes.com';
        }

        self.language(self.records[self.curr()].Type__c);
        var lang = self.language().toLowerCase();
        var question = self.records[self.curr()].Question__c.replace(/\+/g,' ');
		question = unescape(question);

        editor.setOption("mode",syntax[lang]);
        editor.setValue(question);

        for(var i = (EDITOR_MIN_LINES - editor.lineCount()); i > 0; i--){
            var lastLine = editor.lineCount() - 1;
            editor.setLine(lastLine, editor.getLine(lastLine) + '\n');
        }
        self.startTimer();
    };

    self.getAnswer = function(){
        return editor.getValue().replace(/\s/g, "");
    };

    self.submit = function(){
        self.stopTimer();

        var q = {
            id: self.records[self.curr()].Id,
            time: self.getTotalTime(),
            answer: self.getAnswer()
        };

		/**
        alert(["id: " + q.id,
               "time: " + q.time,
               "answer: " + q.answer].join('\n'));
		**/
		//alert('{ question_id: "'+q.id+'", time: '+q.time+', answer: "'+q.answer+'" }')
		var dataString = 'question_id='+ q.id + '&time=' + q.time + '&answer='+encodeURIComponent(q.answer);
		$.ajax({
		  type: 'POST',
		  url: 'http://127.0.0.1:3000/challenges/quickquiz_answer',
		  data: dataString
		});

        self.resetTimer();
        self.loadQuestion(self.curr(self.curr()+1));
    };

    self.loadQuestion(self.curr());

    return self;
}