
var ShiftOption = {
	bindEvents: function() {
		$('.dataTables_wrapper').on('ajax:success', "#move_option_up", this.moveOption);
		$('.dataTables_wrapper').on('ajax:error', "#move_option_up", this.failedResponse);

		$('.dataTables_wrapper').on('ajax:success', "#move_option_down", this.moveOption);
		$('.dataTables_wrapper').on('ajax:error', "#move_option_down", this.failedResponse);		
	},

	moveOption: function(e, data, status, xhr) {
		var otherText, otherTextLink, clickedText, clickedTextLink;

		if(data.valid_click === true) {
			var optionTexts = this.parentElement.parentElement.parentElement.getElementsByClassName('option_text');
			var optionDestroys = this.parentElement.parentElement.parentElement.getElementsByClassName('option_destroy');
			var optionUps = this.parentElement.parentElement.parentElement.getElementsByClassName('move_up');
			var optionDowns = this.parentElement.parentElement.parentElement.getElementsByClassName('move_down');
			var previewOptions = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getElementsByClassName('modal fade')[0].getElementsByClassName(data.question_id);
			var otherOption = previewOptions[data.other_option_order-1];
			var clickOption = previewOptions[data.clicked_option_order-1];

			// Get optionTexts texts and links
			otherText = optionTexts[data.other_option_order-1].innerText;
			otherTextLink = optionTexts[data.other_option_order-1].getAttribute("href");
			clickedText = optionTexts[data.clicked_option_order-1].innerText;
			clickedTextLink = optionTexts[data.clicked_option_order-1].getAttribute("href");			

			// Switch the optionTexts texts and links
			optionTexts[data.other_option_order-1].innerText = clickedText;
			optionTexts[data.other_option_order-1].setAttribute("href", clickedTextLink);
			optionTexts[data.clicked_option_order-1].innerText = otherText;
			optionTexts[data.clicked_option_order-1].setAttribute("href", otherTextLink);

			// Get optionDestroys texts and links
			otherTextLink = optionDestroys[data.other_option_order-1].getAttribute("href");
			clickedTextLink = optionDestroys[data.clicked_option_order-1].getAttribute("href");			

			// Switch the optionDestroys texts and links
			optionDestroys[data.other_option_order-1].setAttribute("href", clickedTextLink);
			optionDestroys[data.clicked_option_order-1].setAttribute("href", otherTextLink);

			// Get optionUps links
			otherTextLink = optionUps[data.other_option_order-1].getAttribute("href");
			clickedTextLink = optionUps[data.clicked_option_order-1].getAttribute("href");			

			// Switch the optionUps links
			optionUps[data.other_option_order-1].setAttribute("href", clickedTextLink);
			optionUps[data.clicked_option_order-1].setAttribute("href", otherTextLink);
		
			// Get optionDowns links
			otherTextLink = optionDowns[data.other_option_order-1].getAttribute("href");
			clickedTextLink = optionDowns[data.clicked_option_order-1].getAttribute("href");			

			// Switch the optionDowns links
			optionDowns[data.other_option_order-1].setAttribute("href", clickedTextLink);
			optionDowns[data.clicked_option_order-1].setAttribute("href", otherTextLink);

			// Switch the options and report text for the preview
			otherText = otherOption.innerHTML;
			clickedText = clickOption.innerHTML;
			otherOption.innerHTML = clickedText;
			clickOption.innerHTML = otherText;
		}
	},

	failedResponse: function() {
		console.log("Something went wrong!");
	} 
};

$(document).ready(function() {
	ShiftOption.bindEvents();
});