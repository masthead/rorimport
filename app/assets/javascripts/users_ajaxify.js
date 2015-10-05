
var failedResponse = function() {
	console.log("Something went wrong!");
};

var gritterAdd = function(title) {
	$.gritter.add({
	  title: title,
	  sticky: false,
	  time: 10001,
	  class_name: "gritter-regular",
	  before_open: function() {
	  	if ($(".gritter-item-wrapper").length === 1) {
	    	false
	  	}
	  }
	});
};

////////////////////////////////////////////////
/////// Update User ////////////////////////////

var getUpdateUserResponse = function(data) {
	if (data.errors === false) {
		var title = "Successfully updated user.";
		
		gritterAdd(title);
	}

	else {
		var title = "Something went wrong. Please reload the page and try again. If the error persists, please contact DealerFocus today.";
		
		gritterAdd(title);
	}
};

var getUserParams = function() {
	var userParams = $('.user_params');
	var userBooleanParams = $('.user_boolean_params');
	var keyName;
	returnUserParams = {};

	for (var i = 0; i < userParams.length; i++) {
		keyName = $('.user_params')[i].id.split('_').slice(1).join('_');
		returnUserParams[keyName] = $('.user_params')[i].value;
	};

	for (var i = 0; i < userBooleanParams.length; i++) {
		keyName = $('.user_boolean_params')[i].id.split('_').slice(1).join('_');
		returnUserParams[keyName] = $('.user_boolean_params')[i].checked;
	};
	
	return returnUserParams;
};

var updateUser = function(e) {
	e.preventDefault();
	var updateUserParams = getUserParams();
	var userId = $('#user_id')[0].value;

	if (userId && parseInt(userId) > 0) {
        ajaxLoader("body");
		var ajaxRequest = $.ajax({
			url: '/users/' + userId + '/update_user',
			type: 'POST',
			data: { user: updateUserParams, user_id: userId },
			dataType: 'json'
		});

		ajaxRequest.done(getUpdateUserResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();
	};
};

////////////////////////////////////////////////
/////// Update User Password ///////////////////

var getUpdateUserPasswordResponse = function(data) {
	if (data.errors === false) {
		var title = "Successfully updated user password.";
		
		gritterAdd(title);
	}

	else {
		var title = "Something went wrong. Please reload the page and try again. If the error persists, please contact DealerFocus today.";
		
		gritterAdd(title);
	}
};

var getUserPasswords = function() {
	var userParams = $('.password_params');
	var userPasswords = {};

	for (var i = 0; i < userParams.length; i++) {
		keyName = userParams[i].id.split('_').slice(1).join('_');
		userPasswords[keyName] = userParams[i].value; 
	};

	return userPasswords;
};

var checkPasswordValditions = function(userPasswords) {
	if ((!(userPasswords.password) && !(userPasswords.password.length > 0)) || (!(userPasswords.password_confirmation) && !(userPasswords.password_confirmation.size > 0))) {
		var title = "Please enter in both a new password and confirm it!";

		gritterAdd(title);

    return false;
	}

	if (userPasswords.password !== userPasswords.password_confirmation) {
		var title = "The password and password confirmation must match!";
		
		gritterAdd(title);

    return false;
	};

	if (userPasswords.password.length < 8 && userPasswords.password_confirmation.length < 8) {
		var title = "The password and password confirmation must be at least 8 characters in length!";
		
		gritterAdd(title);

    return false;		
	}

	return true;
};

var updateUserPassword = function(e) {
	e.preventDefault();
	var userPasswords = getUserPasswords();
	var validationsPassed = checkPasswordValditions(userPasswords);
	var userId = $('#user_id')[0].value;

	if (userId && parseInt(userId) > 0 && validationsPassed) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/users/' + userId + '/update_user',
			type: 'POST',
			data: { user: userPasswords, user_id: userId },
			dataType: 'json'
		});

		ajaxRequest.done(getUpdateUserPasswordResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();
    };
};

////////////////////////////////////////////////
///// Employee /////////////////////////////////

var appendUserEmployee = function(employeeId, jobTitle) {
	return '<tr><td>' + jobTitle + '</td><td><a href="/employees/' + employeeId + '/edit">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/employees/' + employeeId + '" rel="nofollow">Destroy</a></td></tr>';
};

var getNewUserEmployeeResponse = function(data) {
	debugger
	if(data.errors === false) {
		$('#user_employees').append(appendUserEmployee(data.employee.id, data.employee.job_title));
	
		// Reset Input Form
		$('#employee_job_title_id')[0].value = "";
		$("select").trigger("chosen:updated");
	};
};

var createNewUserEmployee = function(e) {
	e.preventDefault();
	var userId = $('#employee_user_id')[0].value;
	var dealerId = $('#employee_dealer_id')[0].value;
	var jobTitleId = $('#employee_job_title_id')[0].value;

	if (dealerId && parseInt(dealerId) > 0 && userId && parseInt(userId) > 0 && jobTitleId && parseInt(jobTitleId) > 0) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/users/' + userId + '/create_employee/',
			type: 'POST',
			data: { job_title_id: jobTitleId, dealer_id: dealerId },
			dataType: 'json'
		});

		ajaxRequest.done(getNewUserEmployeeResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();
    }
};

////////////////////////////////////////////////
///// Add Dealers //////////////////////////////

var getDealerIdsToAdd = function() {
	var dealerInputs = $('.add_dealer');
	var checkedIds = [];

	for (var i = 0; i < dealerInputs.length; i++) {
		if (dealerInputs[i].checked === true && dealerInputs[i].value && (dealerInputs[i].value) > 0) {
			checkedIds.push(dealerInputs[i].value);
		};
	};

	return checkedIds;
};

var getAddDealersResponse = function(data) {
	if (data.errors === false) {
		var dealerIds = data.successfully_added_dealer_ids;
		var checkedDealer, dealerId;
		var userId = data.user_id;

		for (var i = 0; i < dealerIds.length; i++) {
			dealerId = parseInt(dealerIds[i].dealer_id);
			dealerName = dealerIds[i].dealer_name;
			checkedDealer = $('.add_dealer[value="' + dealerId + '"]')[0];
			checkedDealer.parentElement.remove();

			$('.remove_dealers').append('<tr><td>' + dealerName + '</td><td><button class="btn btn-xs btn-warning"><a href="/remove_dealer?dealer_id=' + dealerId + '&user_id=' + userId + '">Remove</a></button></td></tr>');
			
			$('.form-control.input-sm.chosen-select#user_activated_dealer_id').append(
	      '<option value="' + dealerId + '">' + dealerName + '</option>');
		};

		// Update Chosen select
    $("select").trigger("chosen:updated");

		if (dealerIds.length > 1) {
			var title = "Successfully added dealers!";
		}

		else {
			var title = "Successfully added dealer!";
		}

		gritterAdd(title);
	}

	else {
		var title = "Something went wrong. Please reload the page and try again. If the error persists, please contact DealerFocus today.";
		gritterAdd(ttile);
	}
};

var addDealers = function(e) {
	e.preventDefault();

	var user_id = $('#user_id')[0].value;
	var dealerIds = getDealerIdsToAdd();

	if (user_id && parseInt(user_id) > 0) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/users/' + user_id + '/add_dealers/',
			type: 'POST',
			data: { dealer_ids: dealerIds },
			dataType: 'json'
		});

		ajaxRequest.done(getAddDealersResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();
    };
};

////////////////////////////////////////////////
///// Add Call Queues //////////////////////////

var getCallQueueIdsToAdd = function() {
	var callQueueInputs = $('.add_call_queue');
	var checkedIds = [];

	for (var i = 0; i < callQueueInputs.length; i++) {
		if (callQueueInputs[i].checked === true && callQueueInputs[i].value && (callQueueInputs[i].value) > 0) {
			checkedIds.push(callQueueInputs[i].value);
		};
	};

	return checkedIds;
};

var getAddCallQueuesResponse = function(data) {
	if (data.errors === false) {
		var callQueueIds = data.successfully_added_call_queue_ids;
		var checkedCallQueue, callQueueId;
		var userId = data.user_id;
		// debugger;

		for (var i = 0; i < callQueueIds.length; i++) {
			callQueueId = parseInt(callQueueIds[i].call_queue_id);
			callQueueName = callQueueIds[i].call_queue_name;
			checkedDealer = $('.add_call_queue[value="' + callQueueId + '"]')[0];
			checkedDealer.parentElement.remove();

			$('.remove_call_queues').append('<tr><td>' + callQueueName + '</td><td><button class="btn btn-xs btn-warning"><a href="/remove_call_queue?call_queue_id=' + callQueueId + '&user_id=' + userId + '">Remove</a></button></td></tr>');
		};

		if (callQueueIds.length > 1) {
			var title = "Successfully added call queues!";
		}

		else {
			var title = "Successfully added call Queue!";
		}

		gritterAdd(title);
	}

	else {
		var title = "Something went wrong. Please reload the page and try again. If the error persists, please contact DealerFocus today.";
		gritterAdd(ttile);
	}
};

var addCallQueues = function(e) {
	e.preventDefault();

	var user_id = $('#user_id')[0].value;
	var callQueueIds = getCallQueueIdsToAdd();

	if (user_id && parseInt(user_id) > 0) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/users/' + user_id + '/add_call_queues/',
			type: 'POST',
			data: { call_queue_ids: callQueueIds },
			dataType: 'json'
		});

		ajaxRequest.done(getAddCallQueuesResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();
    };
};

////////////////////////////////////////////////

$(document).ready(function() {
	bindEventsUsers();
});

var bindEventsUsers = function() {
	$('.update_user').on('click', updateUser);
	$('.update_user_password').on('click', updateUserPassword);
	$('#user_create_employee').on('click', createNewUserEmployee)
	$('.add_dealers').on('click', addDealers);
	$('.add_call_queues').on('click', addCallQueues);
};