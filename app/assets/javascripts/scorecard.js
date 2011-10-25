/**
* This function takes as input the json string and returns the array of question group objects
* with questions containing all the information required for rendering.
*/
function process_json(input_str) {
	input = $.parseJSON(input_str);
	var key;
	var question_groups = {};
	for (var p in input) {
		key = p;
	}
	input = input[key];
	for (q in input) {
        // for each question in the input json
		var question = input[q];
		var qs_grp_no = question["Question__r"]["QwikScore_Question_Group__r"]["Sequence_Number__c"];
		if (question_groups[qs_grp_no] === undefined) {
            // create a question group if the question group is seen for the first time
            // also store the necessary information for rendering the question group
			var qs_grp = question["Question__r"]["QwikScore_Question_Group__r"];
			question_groups[qs_grp_no] = {"name": qs_grp["Name"], "weight": qs_grp["Group_Weight__c"], "questions": {}};
		}
        // group questions and store the required information for rendering based on the question group they belong to,
        // ordering them as per sequence number
		question_groups[qs_grp_no]["questions"][question["Question__r"]["Sequence_Number__c"]]
			= {"text": question["Question__r"]["Question_Text__c"],
				"weight": question["Question__r"]["Question_Weight__c"],
				"type": question["Question__r"]["Question_Type__c"],
				"min": question["Question__r"]["Minimum_Value__c"],
				"max": question["Question__r"]["Maximum_Value__c"],
				"answer_value": question["Answer_Value__c"],
				"answer_text": question["Answer_Text__c"],
				"isanswered": question["IsAnswered__c"],
				"id": question["Id"]
			};
	}
	return question_groups;
}

/**
* Render each question group into the div.
*/
function scorecard_render(question_groups, container) {
    container = "#"+container;
     for (q in question_groups) {
        // for each question group, render it, and append it to the div container
        $(container).append(question_group_render(question_groups[q]));
    }
}

function question_group_render(ques_grp) {
    // question group boiler plate template
    ques_grp_dom = $('<div class="question_group">'+
        '   <h3>' + ques_grp["name"] + ' - '+ ques_grp["weight"] + '%</h3>'+
        '   <div class="head_outer">'+
        '      <div class="head_inner">'+
        '          <span>Unsatisfactory</span>'+
        '          <span class="head_right">Exceeded Expectations</span>'+
        '      </div>'+
        '   </div>'+
        '   <div class="question_group_content">'+
        '   </div>'+
        '</div>');
    for (q in ques_grp["questions"]) {
        // for each question in the question group, render it and append it to the question group
        ques_grp_dom.children(":last").append(question_render(ques_grp['questions'][q]));
    }
    return ques_grp_dom;
}

function question_render(question) {
    if (question["type"] == "Text") {
		var answer_text = question["answer_text"] != undefined ? question["answer_text"] : '';
        // if question type is Text, render a textarea
        question_class = "q_text";
        question_answer_dom = '<textarea class="scorecard" name="'+question["id"]+'">'+answer_text+'</textarea>';
    } else {
        // else render the radio buttons
        question_class = "q_numeric";
        question_answer_dom = "<table><tr>";
        for (var i=question["min"];i<=question["max"];i++) {
			if ((question["isanswered"] == "1") && (question["answer_value"] == i)) {
            	question_answer_dom += '<td><input class="scorecard" type="radio" name="'+question["id"]+'" value="' +i+ '" checked><br>'+i+'</td>';
			} else {
				question_answer_dom += '<td><input class="scorecard" type="radio" name="'+question["id"]+'" value="' +i+ '"><br>'+i+'</td>';
			}
        }
        question_answer_dom += "</tr></table>";
    }
    var has_weight;
    // the weight percentage of the question is to be shown only if its not 0 (which is the case with Text questions)
    if (question["weight"] != 0) {
        has_weight = " has_weight";
        has_weight_dom = '<div class="question_weight">'+ question["weight"] +'%</div>';
    } else {
        has_weight = "";
        has_weight_dom = "";
    }
    // question boiler plate template
    ques_dom = $('<div class="question_outer">'+
        '   <div class="question '+ question_class +'">'+
        '       <div class="question_answer">'+ question_answer_dom +
        '       </div>'+
        '       <div class="question_content">'+ has_weight_dom +
        '           <div class="question_description' + has_weight +'">' + question["text"] +'</div>'+
        '       </div>'+
        '       <div class="clear"></div>'+
        '   </div>'+
        '</div>');
    return ques_dom;
}

$(document).ready(function() {
    // In the current code, we stored the sample JSON in INPUT_JSON variable,
    // during deployment change it to the appropriate variable containing the json.
	scorecard_render(process_json(INPUT_JSON),"scorecard");
});

/**
* Traverse through all scorecard inputs and build the xml,
* set the xml as the value of a hidden input and submit the form.
*/
function doSubmit(scored) {
     var xml = '<?xml version="1.0" encoding="utf-8"?>'+
                        '<Objects>';
    $("input.scorecard,textarea.scorecard").each(function() {
        if (this.tagName == "INPUT") {
            if (this.checked) {
                // for each radio box in scorecard, capture the value of the radio box thats checked
                xml += '<Object type="QwikScore_Question_Answer__c" id="'+this.name+'"><field id="Answer_Text__c">'+this.value+'</field></Object>';
            }
        } else {
            // for each textarea in scorecard, capture the text filled in
            xml += '<Object type="QwikScore_Question_Answer__c" id="'+this.name+'"><field id="Answer_Text__c">'+this.value+'</field></Object>';
        }
    });
    xml += "</Objects>";
	// set the value of scored
	$('#hidden_scored').val(scored);
    // The generated xml is added as the value of a hidden input of the form
    $('#hiddenxml').val(xml);
    // and the form is submitted
    $('#scorecard_form').submit();
}