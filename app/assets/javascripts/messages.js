
///////////////////////////////////////////
////Helper Functions///////////////////////

var emptyOptions = function() {
	$('option').prop('selected', false);
};

var uncheckOtherAddBoxes = function() {
	for (var i = 0; i < $('.add_box').length; i++) {
		if ($('.add_box')[i].id !== this.id) {
			$('.add_box')[i].checked = false;
		};
	};
};

var selectOption = function(id) {
	for (var i = 0; i < $('option').length; i++) {
		if ($('option')[i].value === id) {
			$('option')[i].selected = true;
		};
	};
};

var removeMessages = function(idsLength, ids) {
	for (var i = 0; i < idsLength; i++) {
		$('.move-to-trash[value="' + ids[i] + '"]')[0].parentElement.parentElement.remove();	
	};	
};

var checkAttribute = function(e) {
	e.preventDefault();

	if (this.getAttribute('checked') === null) {
		this.setAttribute('checked', true);
	}

	else {
		this.removeAttribute('checked');
	};
};

var failedResponse = function() {
	console.log("Something went wrong!");
};

///////////////////////////////////////////
////Reply//////////////////////////////////

var showBodyInput = function(e) {
	e.preventDefault();
	
	if (this.getAttribute('checked') === null) {
		this.setAttribute('checked', true);
		this.innerText = "Cancel";
		this.parentElement.parentElement.children[1].className = "panel-body"
	}

	else {
		this.removeAttribute('checked');
		this.innerText = "Reply";
		this.parentElement.parentElement.children[1].className = "panel-body hide"
	};
};

var getMessageReplyResponse = function(data) {
	if (data.errors === false) {
		var className = this.parentElement.parentElement.className;
		this.parentElement.parentElement.className = className + ' hide';
		this.parentElement.children[1].value = "";
		$('.btn-sm.message-reply#' + data.message_id)[0].removeAttribute('checked');
		$('.btn-sm.message-reply#' + data.message_id)[0].innerText = "Reply";
	};
}

var sendMessageReply = function(e) {
	e.preventDefault();
	var id = this.id;
	var messageBody = this.parentElement.children[1].value;
	if (parseInt(id) > 0 && messageBody !== "") {
		var ajaxRequest = $.ajax({
	    url: '/messages/' + id + '/reply/',
	    type: 'POST',
	    data: { body: messageBody },
	    dataType: 'json'
		});

		ajaxRequest.done(getMessageReplyResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	}

};

///////////////////////////////////////////
////Confirm Message////////////////////////

var getConfirmationResponse = function(data) {
	if (data.marked === true && parseInt(data.message_id) > 0) {
		$('.padding-md .panel .table #' + data.message_id + '.message')[0].children[0].className = "";		
		$('.padding-md .panel .table #' + data.message_id + '.confirm')[0].children[0].className = "";
	};
};

var confirmMessage = function(e) {
	e.preventDefault();

	if ((parseInt(this.id) > 0) && (parseInt(this.id) % 1 == 0)) {
		var messageId = this.id;

		var ajaxRequest = $.ajax({
			url: '/messages/' + messageId + '/confirm_message/',
			type: 'GET'
		});

		ajaxRequest.done(getConfirmationResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	}
};

///////////////////////////////////////////
////Destroy Checked Messages///////////////

var getDestroyCheckedMessagesResponse = function(data) {
	if (data.errors === false) {
		removeMessages(data.ids.length, data.ids);
	};
};

var destroyCheckedMessages = function(e) {
	e.preventDefault();

	var count = $('.move-to-trash[checked="true"]').length;

	if (count > 0) {
		var ids = []
		for(var i = 0; i < count; i++) {
			ids.push($('.move-to-trash[checked="true"]')[i].value);
		};

		var ajaxRequest = $.ajax({
			url: '/safe_destroy',
			type: "POST",
			data: { ids: ids },
			dataType: 'json'
		});

		ajaxRequest.done(getDestroyCheckedMessagesResponse.bind(this));
		ajaxRequest.fail(failedResponse);

	}
};

///////////////////////////////////////////
////Move Checked to Trash//////////////////

var getMoveToTrashResponse = function(data) {
	if (data.errors === false) {
		removeMessages(data.ids.length, data.ids);
	}
};

var moveToTrash = function(e) {
	e.preventDefault();
	var count = $('.move-to-trash[checked="true"]').length;

	if (count > 0) {
		var ids = []
		for(var i = 0; i < count; i++) {
			ids.push($('.move-to-trash[checked="true"]')[i].value);
		};

		var ajaxRequest = $.ajax({
			url: '/messages/move_checked_to_trash/',
			type: "POST",
			data: { ids: ids },
			dataType: 'json'
		});

		ajaxRequest.done(getMoveToTrashResponse);
		ajaxRequest.fail(failedResponse);
	};
};

///////////////////////////////////////////
////Check Read/////////////////////////////

var getReadResponse = function(data) {
	if (data.marked === true) {
		this.parentElement.children[1].children[0].remove();
	};
};

var checkRead = function(e) {
	e.preventDefault();

	if (this.id === "inbox" || this.id === "trash") {
		var id = this.getAttribute('href').split('_')[1];
		var ajaxRequest = $.ajax({
			url: '/messages/' + id + '/read/',
			type: 'GET'
		});

		ajaxRequest.done(getReadResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

///////////////////////////////////////////
////Add All////////////////////////////////

var addAll = function(e) {
	e.preventDefault();

	uncheckOtherAddBoxes.bind(this)();

	if (this.checked === true) {
		$('option').prop('selected', true);
  }

	else {
		emptyOptions();
	};
  
  $('select').trigger("chosen:updated");	
};

///////////////////////////////////////////
////Agents/////////////////////////////////

var getAllAgentsResponse = function(data) {
	if (data.errors === false) {
		for (var i = 0; i < data.all_agents.length; i++) {
			selectOption(data.all_agents[i]);
		};
  	$('select').trigger("chosen:updated");	
	};
};

var getAllAgents = function(e) {
	e.preventDefault();

	uncheckOtherAddBoxes.bind(this)();

	if (this.checked === true) {
		emptyOptions();

		var ajaxRequest = $.ajax({
			url: "/messages/all/agents/",
			type: "GET"
		});

		ajaxRequest.done(getAllAgentsResponse);
		ajaxRequest.fail(failedResponse);
	}

	else {
		emptyOptions();
		$('select').trigger("chosen:updated");
	};
};

///////////////////////////////////////////
////Managers///////////////////////////////

var getAllManagersResponse = function(data) {
	if (data.errors === false) {
		for (var i = 0; i < data.all_managers.length; i++) {
			selectOption(data.all_managers[i]);
		};
  	$('select').trigger("chosen:updated");	
	};
};

var getAllManagers = function(e) {
	e.preventDefault();

	uncheckOtherAddBoxes.bind(this)();

	if (this.checked === true) {
		emptyOptions();

		var ajaxRequest = $.ajax({
			url: '/messages/all/managers/',
			type: 'GET'
		});

		ajaxRequest.done(getAllManagersResponse);
		ajaxRequest.fail(failedResponse);
	}

	else {
		emptyOptions();
		$('select').trigger("chosen:updated");
	};
};

///////////////////////////////////////////

var bindEventsMessages = function() {
	$('#add_all').on('change', addAll);

	$('#add_all_agents').on('change', getAllAgents);

	$('#add_all_managers').on('change', getAllManagers);

	$('.message#inbox').on('click', checkRead);
	$('.message#trash').on('click', checkRead);

	$('.move-to-trash').on('change', checkAttribute);

	$('.move-checked-to-trash').on('click', moveToTrash);

	$('.destroy_checked_messages').on('click', destroyCheckedMessages);

	$('.btn-success.confirm').on('click', confirmMessage);

	$('.btn-default.message-reply').on('click', showBodyInput);
	$('.btn-success.message-reply-send').on('click', sendMessageReply);	
};

$(document).ready(function() {
	bindEventsMessages();
});	
