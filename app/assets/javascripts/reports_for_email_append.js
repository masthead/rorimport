
var emailAppend = function(e) {
	e.preventDefault();
	var search_choices = $('.search-choice'), email;
	var emailInput = $('.text.optional.form-control.input-sm')[0].value;

	if(search_choices.length === 0) {
		return;
	}

	if(search_choices.length == 1) {
		email = search_choices[0].innerText;
		if(emailInput === "") {
			$('.text.optional.form-control.input-sm')[0].value = email;		
		}

		else {
			if(emailInput[emailInput.length-1] === ',') {
				$('.text.optional.form-control.input-sm')[0].value = emailInput + ' ' + email;
			}

			else if(emailInput[emailInput.length-1] === ' ' && emailInput[emailInput.length-2] === ',') {
				$('.text.optional.form-control.input-sm')[0].value = emailInput + email;				
			}

			else {
				$('.text.optional.form-control.input-sm')[0].value = emailInput + ', ' + email;
			};
		};
	}

	else {

		if(emailInput !== "") {
			if(emailInput[emailInput.length-1] === ',') {
				emailInput = emailInput + ' ';
			}

			else {
				emailInput = emailInput + ', ';
			};
		};

		for(var i = 0; i < search_choices.length; i++) {
			if(i === search_choices.length - 1) {
				emailInput = emailInput + search_choices[i].innerText;
			}

			else {
				emailInput = emailInput + search_choices[i].innerText + ', ';	
			};
		};
		$('.text.optional.form-control.input-sm')[0].value = emailInput;
	};
};

var bindEventsEmailAppend = function() {
	$('.btn.btn-sm#append').on('click', emailAppend);
};

$(document).ready(function() {
	bindEventsEmailAppend();
});