
var ShiftQuestion = {
	bindEvents: function() {
		$('.dataTables_wrapper').on('ajax:success', "#move_question_up", this.moveQuestion);
		$('.dataTables_wrapper').on('ajax:error', "#move_question_up", this.failedResponse);

		$('.dataTables_wrapper').on('ajax:success', "#move_question_down", this.moveQuestion);
		$('.dataTables_wrapper').on('ajax:error', "#move_question_down", this.failedResponse);		
	}, 

	moveQuestion: function(e, data, status, xhr) {
		var otherText, otherTextLink, clickedText, clickTextLink;

		if(data.valid_click === true) {
			var questionTexts = this.parentElement.parentElement.parentElement.getElementsByClassName('question_text');
			var reportTexts = this.parentElement.parentElement.parentElement.getElementsByClassName('report_question_text');
			var questionTypes = this.parentElement.parentElement.parentElement.getElementsByClassName('question_type');
			var questionDestroys = this.parentElement.parentElement.parentElement.getElementsByClassName('question_destroy');
			var questionUps = this.parentElement.parentElement.parentElement.getElementsByClassName('move_up');
			var questionDowns = this.parentElement.parentElement.parentElement.getElementsByClassName('move_down');
			var previewQuestions = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByClassName('modal fade')[0].getElementsByClassName('question')
			var previewReportTextsOptions = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByClassName('modal fade')[0].getElementsByClassName('question_options')

			// Get questionText texts & links to switch
			otherText = questionTexts[data.other_question_order-1].innerText;
			otherTextLink = questionTexts[data.other_question_order-1].getAttribute("href");
			
			clickedText = questionTexts[data.clicked_question_order-1].innerText;
			clickedTextLink = questionTexts[data.clicked_question_order-1].getAttribute("href");

			// Switch the questionText texts & links
			questionTexts[data.clicked_question_order-1].innerText = otherText;
			questionTexts[data.clicked_question_order-1].setAttribute("href", otherTextLink);
			
			questionTexts[data.other_question_order-1].innerText = clickedText;
			questionTexts[data.other_question_order-1].setAttribute("href", clickedTextLink);
		
			// Get reportTexts texts & links to switch
			otherText = reportTexts[data.other_question_order-1].innerText;
			otherTextLink = reportTexts[data.other_question_order-1].getAttribute("href");
			
			clickedText = reportTexts[data.clicked_question_order-1].innerText;
			clickedTextLink = reportTexts[data.clicked_question_order-1].getAttribute("href");			

			// Switch the reportText texts & links
			reportTexts[data.clicked_question_order-1].innerText = otherText;
			reportTexts[data.clicked_question_order-1].setAttribute("href", otherTextLink);
			
			reportTexts[data.other_question_order-1].innerText = clickedText;
			reportTexts[data.other_question_order-1].setAttribute("href", clickedTextLink);

			// Get questionTypes texts & links to switch
			otherText = questionTypes[data.other_question_order-1].innerText;
			otherTextLink = questionTypes[data.other_question_order-1].getAttribute("href");
			
			clickedText = questionTypes[data.clicked_question_order-1].innerText;
			clickedTextLink = questionTypes[data.clicked_question_order-1].getAttribute("href");			

			// Switch the questionTypes texts & links
			questionTypes[data.clicked_question_order-1].innerText = otherText;
			questionTypes[data.clicked_question_order-1].setAttribute("href", otherTextLink);
			
			questionTypes[data.other_question_order-1].innerText = clickedText;
			questionTypes[data.other_question_order-1].setAttribute("href", clickedTextLink);
		
			// Get questionUps links to switch
			otherTextLink = questionUps[data.other_question_order-1].getAttribute("href");
			
			clickedTextLink = questionUps[data.clicked_question_order-1].getAttribute("href");			

			// Switch the questionUps links
			questionUps[data.clicked_question_order-1].setAttribute("href", otherTextLink);

			questionUps[data.other_question_order-1].setAttribute("href", clickedTextLink);

			// Get questionUps links to switch
			otherTextLink = questionDowns[data.other_question_order-1].getAttribute("href");
			
			clickedTextLink = questionDowns[data.clicked_question_order-1].getAttribute("href");			

			// Switch the questionUps links
			questionDowns[data.clicked_question_order-1].setAttribute("href", otherTextLink);

			questionDowns[data.other_question_order-1].setAttribute("href", clickedTextLink);

			// Get optionDestroys texts and links
			otherTextLink = questionDestroys[data.other_question_order-1].getAttribute("href");
			clickedTextLink = questionDestroys[data.clicked_question_order-1].getAttribute("href");			

			// Switch the optionDestroys texts and links
			questionDestroys[data.other_question_order-1].setAttribute("href", clickedTextLink);
			questionDestroys[data.clicked_question_order-1].setAttribute("href", otherTextLink);
		
			// Switch the questions for the preview
			otherText = previewQuestions[data.other_question_order-1].innerHTML;
			clickedText = previewQuestions[data.clicked_question_order-1].innerHTML;
			previewQuestions[data.other_question_order-1].innerHTML = clickedText;
			previewQuestions[data.clicked_question_order-1].innerHTML = otherText;

			// Switch the options and report text for the preview
			otherText = previewReportTextsOptions[data.other_question_order-1].innerHTML;
			clickedText = previewReportTextsOptions[data.clicked_question_order-1].innerHTML;
			previewReportTextsOptions[data.other_question_order-1].innerHTML = clickedText;
			previewReportTextsOptions[data.clicked_question_order-1].innerHTML = otherText;
		}
	},

	failedResponse: function() {
		console.log("Something went wrong!");
	}
};

$(document).ready(function() {
	ShiftQuestion.bindEvents();
});