
/////////////////////////////////////////////////////
// Helpers //////////////////////////////////////////

var checkFirstEndButton = function() {
		if(this === this.parentElement.children[0]) {
			endButton = true;
		}

		else {
			endButton = false;
		};

		return endButton;
};

var checkLastEndButton = function() {
	if(this === this.parentElement.children[4]) {
		endButton = true;
	}

	else {
		endButton = false;
	};

	return endButton;
};

var switchButtonsNext = function(endbuttonBoolean, prev, middle, next) {
	if(endbuttonBoolean === "true") {
		this.parentElement.children[3].id = next;
	}

	else {
		this.id = next;
	};

	this.parentNode.children[1].id = prev;
	this.parentNode.children[2].id = middle;
	this.parentNode.children[2].innerHTML = middle;	
};

var switchButtonsPrev = function(endbuttonBoolean, prev, middle, next) {
	if(endbuttonBoolean === "true") {
		this.parentElement.children[1].id = prev;
	}

	else {
		this.id = prev;
	};	

	this.parentNode.children[3].id = next;
	this.parentNode.children[2].id = middle;
	this.parentNode.children[2].innerHTML = middle;
};

var checkRightLimits = function() {
	return (this.classList.contains("next") && parseInt(this.id) <= parseInt(this.parentElement.children[4].id)) || (this.classList.contains("last") && parseInt(this.parentElement.children[3].id) <= parseInt(this.id));
};

var checkLeftLimits = function() {
	return ((this.classList.contains("prev") && parseInt(this.id) > 0)) || ((this.classList.contains("first") && parseInt(this.parentElement.children[1].id) > 0));
};

var resetButtonValues = function() {
	var prevButtons = $('.btn-toolbar.no-margin .prev');
	var middleButtons = $('.btn-toolbar.no-margin .middle-count');
	var nextButtons = $('.btn-toolbar.no-margin .next');

	for (var i = 0; i < prevButtons.length; i++) {
		prevButtons[i].id = 0;
	};

	for (var i = 0; i < middleButtons.length; i++) {
		middleButtons[i].id = 1;
		middleButtons[i].innerText = 1;
	};

	for (var i = 0; i < nextButtons.length; i++) {
		nextButtons[i].id = 2;
	};

	return;
};

var failedResponse = function() {
	console.log("Something went wrong!!");
};

///////////////////////////////////////
////// Set Up Box Colors //////////////

var removeColorClass = function(button) {
	if ($(button) && $(button).length > 0) {
		var classNames = $(button)[0].parentElement.className.split(" ");

		var editedClassNames = [];
		for (var i = 0; i < classNames.length; i++) {
			if (classNames[i] !== 'bg-success' && classNames[i] !== 'bg-warning' && classNames[i] !== 'bg-danger') {
				editedClassNames.push(classNames[i]);
			};
		};

		$(button)[0].parentElement.className = editedClassNames.join(" ");
	};
};

var setUpAverageHoldTimeBoxColor = function(average_hold_time) {
	if ($('#average-hold-time-button') && $('#average-hold-time-button').length > 0) {
	  if (average_hold_time >= 30 && average_hold_time < 60) {
	      removeColorClass('#average-hold-time-button');
	      $('#average-hold-time-button')[0].parentElement.className += " bg-warning";
	  }

	  else if (average_hold_time >= 60) {
	      removeColorClass('#average-hold-time-button');
	      $('#average-hold-time-button')[0].parentElement.className += " bg-danger";
	  }

	  else {
	      removeColorClass('#average-hold-time-button');
	      $('#average-hold-time-button')[0].parentElement.className += " bg-success";
	  }
	};
};

var setUpLongestHoldTimeBoxColor = function(longest_hold_time) {
	if ($('#longest-hold-time-button') && $('#longest-hold-time-button').length > 0) {
		if (longest_hold_time >= 180 && longest_hold_time < 360) {
	      removeColorClass('#longest-hold-time-button');
	      $('#longest-hold-time-button')[0].parentElement.className += " bg-warning";
	  }

	  else if (longest_hold_time >= 360) {
	      removeColorClass('#longest-hold-time-button');
	      $('#longest-hold-time-button')[0].parentElement.className += " bg-danger";
	  }

	  else {
	      removeColorClass('#longest-hold-time-button');
	      $('#longest-hold-time-button')[0].parentElement.className += " bg-success";
	  }
	};
};

var setUpBoxColors = function() {

	// Agents Online Box
	if ($('#agents-online-button .text-right .value') && $('#agents-online-button .text-right .value').length > 0 && $('#agents-online-button .text-right .value')[0].innerText.length > 0) {
		var agents_online_count = parseInt($('#agents-online-button .text-right .value')[0].innerText);

		if (agents_online_count >= 10) {
			removeColorClass('#agents-online-button');
			
			if (agents_online_count >= 16) {
				$('#agents-online-button')[0].parentElement.className += " bg-success";
			}

			else {
				$('#agents-online-button')[0].parentElement.className += " bg-warning";
			}
		}
	};

	// Inbound Calls Waiting Box
	if ($('#inbound-calls-waiting-button .text-right .value') && $('#inbound-calls-waiting-button .text-right .value').length > 0 && $('#inbound-calls-waiting-button .text-right .value')[0].innerText.length > 0) {
		var inbound_calls_waiting_count = parseInt($('#inbound-calls-waiting-button .text-right .value')[0].innerText);

		if (inbound_calls_waiting_count >= 5) {
			removeColorClass('#inbound-calls-waiting-button');
			
			if (inbound_calls_waiting_count >= 11) {
				$('#inbound-calls-waiting-button')[0].parentElement.className += " bg-danger";
			}

			else {
				$('#inbound-calls-waiting-button')[0].parentElement.className += " bg-warning";
			}
		}
	};

	// Agents On Pause Box
	if ($('#agents-idle-button .text-right .value') && $('#agents-idle-button .text-right .value').length > 0 && $('#agents-idle-button .text-right .value')[0].innerText.length > 0) {
		var idle_agents_count = parseInt($('#agents-idle-button .text-right .value')[0].innerText);

		if (idle_agents_count >= 3) {
			removeColorClass('#agents-idle-button');
			
			if (idle_agents_count >= 6) {
				$('#agents-idle-button')[0].parentElement.className += " bg-danger";
			}

			else {
				$('#agents-idle-button')[0].parentElement.className += " bg-warning";
			}
		}
	};
};

///////////////////////////////////////
////// Set Up Clocks //////////////////

// var setUpAverageHoldTimeClock = function() {
// 	if ($('#average_hold_time') && $('#average_hold_time').length > 0 && parseInt($('#average_hold_time')[0].innerText) % 1 == 0 && parseInt($('#average_hold_time')[0].innerText) > 0) {
// 		average_hold_time = parseInt($('#average_hold_time')[0].innerText);

// 	  var clock = $('#average_hold_time').FlipClock(3600, {
// 	  	autoStart: false,
// 	  	clockFace: "MinuteCounter"
// 	  });

// 	  clock.setTime(average_hold_time);

// 	  setUpAverageHoldTimeBoxColor(average_hold_time);
// 	}

// 	else {
// 		if ($('#average_hold_time')) {
// 		  var clock = $('#average_hold_time').FlipClock(3600, {
// 		  	autoStart: false,
// 		  	clockFace: "MinuteCounter"
// 		  });

// 		  clock.setTime(0);

// 		  setUpAverageHoldTimeBoxColor(0);
// 		}
// 	}  
// };

// var setUpLongestHoldTimeClock = function() {
// 	if ($('#longest_hold_time') && $('#longest_hold_time').length > 0 && parseInt($('#longest_hold_time')[0].innerText) % 1 == 0 && parseInt($('#longest_hold_time')[0].innerText) > 0) {
// 		longest_hold_time = parseInt($('#longest_hold_time')[0].innerText);

// 	  var clock = $('#longest_hold_time').FlipClock(3600, {
// 	  	clockFace: "MinuteCounter"
// 	  });

// 	  clock.setTime(longest_hold_time);

// 	  setUpLongestHoldTimeBoxColor(longest_hold_time);
// 	}

// 	else {
// 		if ($('#longest_hold_time')) {
// 		  var clock = $('#longest_hold_time').FlipClock(3600, {
// 		  	autoStart: false,
// 		  	clockFace: "MinuteCounter"
// 		  });

// 		  clock.setTime(0);

// 		  setUpLongestHoldTimeBoxColor(0);
// 		}
// 	}
// };


///////////////////////////////////////
////// Online Agents //////////////////

var appendAgentInformation = function(agentName, agentEmail, agentStatus, agentTimestamp, userId) {
	return '<tr><td>' + agentName + '</td><td>' + agentEmail + '</td><td>' + agentStatus + '</td><td>' + agentTimestamp + '</td><td><a href="/users/' + userId + '">More Details</a></td></tr>';
};

var onlineAgentsInformationResponse = function(data) {
	if (data.errors === false) {
		var modalId = data.agent_modal;

		if (modalId === "1" && $('#agents_logged_in') && $('#agents_logged_in').length > 0 && data.total_agents_online > (-1)) {
			$('#agents_logged_in')[0].innerText = data.total_agents_online;
		};

		if (modalId === "2" && $('#agents_on_calls') && $('#agents_on_calls').length > 0 && data.total_agents_online > (-1)) {
			$('#agents_on_calls')[0].innerText = data.total_agents_online;
		};

		if (modalId === "3" && $('#agents_on_idle') && $('#agents_on_idle').length > 0 && data.total_agents_online > (-1)) {
			$('#agents_on_idle')[0].innerText = data.total_agents_online;
		};				

		for (var i = 0; i < data.page_agents_online; i++) {
			$('#' + modalId + '.agents_online_information').append(appendAgentInformation(data.agent_names[i], data.agent_emails[i], data.agent_statuses[i], data.agent_timestamps[i], data.user_ids[i]));
		};
	};
};

var nextOnlineAgentsInformationResponse = function(data) {
	if(data.errors === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var modalId = data.agent_modal;
		$('#' + modalId + '.agents_online_information').children().remove();

		for (var i = 0; i < data.total_agents_online; i++) {
			$('#' + modalId + '.agents_online_information').append(appendAgentInformation(data.agent_names[i], data.agent_emails[i], data.agent_statuses[i], data.agent_timestamps[i], data.user_ids[i]));
		};
	}

	else {
		var modalId = data.agent_modal;
		$('#' + modalId + '.agents_online_information').children().remove();
		$('#' + modalId + '.agents_online_information').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var prevOnlineAgentsInformationResponse = function(data) {
	if(data.errors === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var modalId = data.agent_modal;
		$('#' + modalId + '.agents_online_information').children().remove();

		for (var i = 0; i < data.total_agents_online; i++) {
			$('#' + modalId + '.agents_online_information').append(appendAgentInformation(data.agent_names[i], data.agent_emails[i], data.agent_statuses[i], data.agent_timestamps[i], data.user_ids[i]));
		};
	}

	else {
		var modalId = data.agent_modal;
		$('#' + modalId + '.agents_online_information').children().remove();
		$('#' + modalId + '.agents_online_information').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var getOnlineAgentsInformation = function(e) {
	e.preventDefault();

	resetButtonValues();

	var agentModal = "";

	var totalAgents = jQuery(this).find(".value")[0].innerText.trim();

	if(parseInt(totalAgents) === 0 && this.getAttribute('href').length > 0) {
		this.setAttribute('href', '');
	}

	else {
		if (parseInt(totalAgents) !== 0 && this.getAttribute('href').length === 0) {
			if (this.id === "agents-online-button") {
				this.setAttribute('href', '#agents-online-1');
			};

			if (this.id === "agents-on-call-button") {
				this.setAttribute('href', '#agents-online-2');
			};

			if (this.id === "agents-idle-button") {
				this.setAttribute('href', '#agents-online-3');
			};
		}

		if (this.getAttribute('href').length > 0) {
			agentModal = this.getAttribute('href').split('-')[this.getAttribute('href').split('-').length - 1];
		}
	};

	if (parseInt(totalAgents) > 0 && agentModal.length > 0) {
		$('#' + agentModal + '.agents_online_information').children().remove();
		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_online_agents/',
			type: 'GET',
			data: { agent_modal: agentModal },
			dataType: 'json'
		});

		ajaxRequest.done(onlineAgentsInformationResponse);
		ajaxRequest.fail(failedResponse);
	};
};

var getNextOnlineAgentsInformation = function(e) {
	e.preventDefault();
	var agentModal = jQuery(this).parents(".btn-group")[0].id;

	if (checkRightLimits.bind(this)() && parseInt(agentModal) > 0) {
		var offsetCounter = this.id, endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_online_agents/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true, agent_modal: agentModal },
		  dataType: 'json'
		});

		ajaxRequest.done(nextOnlineAgentsInformationResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getPrevOnlineAgentsInformation = function(e) {
	e.preventDefault();
	var agentModal = jQuery(this).parents(".btn-group")[0].id;

	if (checkLeftLimits.bind(this)() && parseInt(agentModal) > 0) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_online_agents/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true, agent_modal: agentModal },
		  dataType: 'json'
		});

		ajaxRequest.done(prevOnlineAgentsInformationResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
}

///////////////////////////////////////
////// Outbound Calls in Queue ////////

var appendOutboundCallsInQueueWithSurvey = function(campaignName, customerName, homePhone, workPhone, cellPhone, customerSurveyId, dealerId) {
	return '<tr><td>' + campaignName + '</td><td>' + customerName + '</td><td>' + homePhone + '</td><td>' + workPhone + '</td><td>' + cellPhone + '</td><td><a href="/dealers/' + dealerId + '/surveys/' + customerSurveyId + '">View Survey</a></td></tr>';
};

var appendOutboundCallsInQueueWithoutSurvey = function(campaignName, customerName, homePhone, workPhone, cellPhone) {
	return '<tr><td>' + campaignName + '</td><td>' + customerName + '</td><td>' + homePhone + '</td><td>' + workPhone + '</td><td>' + cellPhone + '</td><td></td></tr>';
};

var getOutboundCallsInQueueResponse = function(data) {
	if (data.errors === false) {
		if ($('#active_calls') && $('#active_calls').length > 0 && data.total_outbound_calls > (-1)) {
			$('#active_calls')[0].innerText = data.total_outbound_calls;
		};

		for (var i = 0; i < data.outbound_calls_for_page; i++) {
			if (parseInt(data.dealer_ids[i]) > 0 && parseInt(data.customer_surveys[i]) > 0) {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.customer_surveys[i], data.dealer_ids[i]));	
			}

			else {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithoutSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i]));	
			};
		};
	};
};

var nextOutboundCallsInQueueResponse = function(data) {
	if(data.errors === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.outbound_calls_in_queue').children().remove();

		for (var i = 0; i < data.outbound_calls_for_page; i++) {
			if (parseInt(data.dealer_ids[i]) > 0 && parseInt(data.customer_surveys[i]) > 0) {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.customer_surveys[i], data.dealer_ids[i]));	
			}

			else {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithoutSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i]));	
			};
		};
	}

	else {
		$('.outbound_calls_in_queue').children().remove();
		$('.outbound_calls_in_queue').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var prevOutboundCallsInQueueResponse = function(data) {
	if(data.errors === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.outbound_calls_in_queue').children().remove();

		for (var i = 0; i < data.outbound_calls_for_page; i++) {
			if (parseInt(data.dealer_ids[i]) > 0 && parseInt(data.customer_surveys[i]) > 0) {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.customer_surveys[i], data.dealer_ids[i]));	
			}

			else {
				$('.outbound_calls_in_queue').append(appendOutboundCallsInQueueWithoutSurvey(data.campaign_names[i], data.customer_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i]));	
			};
		};
	}

	else {
		$('.outbound_calls_in_queue').children().remove();
		$('.outbound_calls_in_queue').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var getOutboundCallsInQueue = function(e) {
	e.preventDefault();

	resetButtonValues();
	$('.outbound_calls_in_queue').children().remove();

	var totalOutboundCallsInQueue = jQuery(this).find(".value")[0].innerText.trim();

	if(parseInt(totalOutboundCallsInQueue) === 0 && this.getAttribute('href').length > 0) {
		this.setAttribute('href', '');
	}

	else {
		if (parseInt(totalOutboundCallsInQueue) !== 0 && this.getAttribute('href').length === 0) {
			if (this.id === "outbound-calls-in-queue-button") {
				this.setAttribute('href', '#outbound-calls-in-queue');
			};
		};
	};

	if (parseInt(totalOutboundCallsInQueue) > 0) {
		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_outbound_calls_in_queue/',
			type: 'GET'
		});

		ajaxRequest.done(getOutboundCallsInQueueResponse);
		ajaxRequest.fail(failedResponse);
	};
};

var getNextOutboundCallsInQueue = function(e) {
	e.preventDefault();

	if (checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_outbound_calls_in_queue/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(nextOutboundCallsInQueueResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getPrevOutboundCallsInQueue = function(e) {
	e.preventDefault();

	if (checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_outbound_calls_in_queue/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(prevOutboundCallsInQueueResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

///////////////////////////////////////
////// Inbound Calls Waiting //////////

var appendInboundCalls = function(customerName, callQueueName, agentName, callId) {
	return '<tr><td>' + customerName + '</td><td>' + callQueueName + '</td><td>' + agentName + '</td><td><a href="/calls/' + callId + '" target="_blank">View Call Details</a></td></tr>';
};

var inboundCallsWaitingResponse = function(data) {
	if (data.errors === false) {
		if ($('#calls_waiting') && $('#calls_waiting').length > 0 && data.total_inbound_calls > (-1)) {
			$('#calls_waiting')[0].innerText = data.total_inbound_calls;
		};

		for (var i = 0; i < data.inbound_calls_for_page; i++) {
			$('.inbound_calls_waiting').append(appendInboundCalls(data.customer_names[i], data.call_queue_names[i], data.agent_names[i], data.call_ids[i]));
		};
	}
};

var nextInboundCallsWaitingResponse = function(data) {
	if(data.errors === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.inbound_calls_waiting').children().remove();

		for (var i = 0; i < data.inbound_calls_for_page; i++) {
			$('.inbound_calls_waiting').append(appendInboundCalls(data.customer_names[i], data.call_queue_names[i], data.agent_names[i], data.call_ids[i]));
		};
	}

	else {
		$('.inbound_calls_waiting').children().remove();
		$('.inbound_calls_waiting').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var prevInboundCallsWaitingResponse = function(data) {
	if(data.errors === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.inbound_calls_waiting').children().remove();

		for (var i = 0; i < data.inbound_calls_for_page; i++) {
			$('.inbound_calls_waiting').append(appendInboundCalls(data.customer_names[i], data.call_queue_names[i], data.agent_names[i], data.call_ids[i]));
		};
	}

	else {
		$('.inbound_calls_waiting').children().remove();
		$('.inbound_calls_waiting').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var getInboundCallsWaiting = function(e) {
	e.preventDefault();

	resetButtonValues();
	$('.inbound_calls_waiting').children().remove();

	var totalIncomingCallsWaiting = jQuery(this).find(".value")[0].innerText.trim();

	if(parseInt(totalIncomingCallsWaiting) === 0 && this.getAttribute('href').length > 0) {
		this.setAttribute('href', '');
	}

	else {
		if (parseInt(totalIncomingCallsWaiting) !== 0 && this.getAttribute('href').length === 0) {
			if (this.id === "inbound-calls-waiting-button") {
				this.setAttribute('href', '#inbound-calls-waiting');
			};
		};
	};

	if (parseInt(totalIncomingCallsWaiting) > 0) {
		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_inbound_calls_waiting/',
			type: 'GET'
		});

		ajaxRequest.done(inboundCallsWaitingResponse);
		ajaxRequest.fail(failedResponse);
	};	
};

var getNextInboundCallsWaiting = function(e) {
	e.preventDefault();

	if (checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_inbound_calls_waiting/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(nextInboundCallsWaitingResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getPrevInboundCallsWaiting = function(e) {
	e.preventDefault();

	if (checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_inbound_calls_waiting/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(prevInboundCallsWaitingResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

///////////////////////////////////////
////// Total Calls ////////////////////

var appendTotalCallsNoAudio = function(callTimestamp, fromNumber, toNumber, direction, customerName) {
	return '<tr><td>' + callTimestamp + '</td><td>' + fromNumber + '</td><td>' + toNumber + '</td><td>' + direction + '</td><td>' + customerName + '</td><td></td></tr>';
};

var appendTotalCallsWithAudio = function(callTimestamp, fromNumber, toNumber, direction, customerName, recording_url, id) {
  var horrendous = '<div class="jp-jplayer" id="jquery_jplayer_' + id + '"></div>' +
                      '<div aria-label="media player" class="jp-audio" id="jp_container_' + id + '" role="application">' +
                          '<div class="jp-type-single">' +
                              '<div class="jp-gui jp-interface">' +
                                  '<div class="jp-controls-holder">' +
                                      '<div class="jp-controls">' +
                                          '<a class="btn btn-xs btn-info jp-play" role="button" tabindex="0">Play</a>' +
                                          '<a class="btn btn-xs btn-info jp-pause" role="button" tabindex="0">Pause</a>' +
                                      '</div>' +
                                  '</div>' +
                              '</div>' +
                          '</div>' +
                      '</div>' +
                      '<script>' +

                          '$("#jquery_jplayer_' + id + '").jPlayer({' +
                              'ready: function () {' +
                                  '$(this).jPlayer("setMedia", {' +
                                      'mp3: "' + recording + '",' +
                                  '});' +
                              '},' +
                              'cssSelectorAncestor: "#jp_container_' + id + '",' +
                              'solution: "flash,html",' +
                              'swfPath: "/swf/jquery.jplayer.swf",' +
                              'supplied: "mp3"' +
                          '});' +

                      '</script>'
return '<tr><td>' + callTimestamp + '</td><td>' + fromNumber + '</td><td>' + toNumber + '</td><td>' + direction + '</td><td>' + customerName + '</td><td>' + horrendous + '</td></tr>';
};

var getTotalCallsResponse = function(data) {
	if (data.errors === false) {
		if ($('#total_calls_today') && $('#total_calls_today').length > 0 && data.total_calls_for_entire_day > (-1)) {
			$('#total_calls_today')[0].innerText = data.total_calls_for_entire_day;
		};

		for (var i = 0; i < data.total_calls_for_page; i++) {
			if (data.recording_urls[i] !== null && data.recording_urls[i].length > 0) {
				$('.total_calls').append(appendTotalCallsWithAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i], data.recording_urls[i], data.call_ids[i]));	
			}

			else {
				$('.total_calls').append(appendTotalCallsNoAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i]));		
			}
		}
	}
};

var nextTotalCallsResponse = function(data) {
	if(data.errors === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.total_calls').children().remove();

		for (var i = 0; i < data.total_calls_for_page; i++) {
			if (data.recording_urls[i] !== null && data.recording_urls[i].length > 0) {
				$('.total_calls').append(appendTotalCallsWithAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i], data.recording_urls[i], data.call_ids[i]));	
			}

			else {
				$('.total_calls').append(appendTotalCallsNoAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i]));		
			}
		}
	}

	else {
		$('.total_calls').children().remove();
		$('.total_calls').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var prevTotalCallsResponse = function(data) {
	if(data.errors === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		$('.total_calls').children().remove();

		for (var i = 0; i < data.total_calls_for_page; i++) {
			if (data.recording_urls[i] !== null && data.recording_urls[i].length > 0) {
				$('.total_calls').append(appendTotalCallsWithAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i], data.recording_urls[i], data.call_ids[i]));	
			}

			else {
				$('.total_calls').append(appendTotalCallsNoAudio(data.call_timestamps[i], data.from_numbers[i], data.to_numbers[i], data.directions[i], data.customer_names[i]));		
			}
		}
	}

	else {
		$('.total_calls').children().remove();
		$('.total_calls').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td><td></td><td></td><td></td><td></td></tr>");;
	}
};

var getTotalCalls = function(e) {
	e.preventDefault();

	resetButtonValues();
	$('.total_calls').children().remove();

	var totalCalls = jQuery(this).find(".value")[0].innerText.trim();

	if(parseInt(totalCalls) === 0 && this.getAttribute('href').length > 0) {
		this.setAttribute('href', '');
	}

	else {
		if (parseInt(totalCalls) !== 0 && this.getAttribute('href').length === 0) {
			if (this.id === "total-calls-button") {
				this.setAttribute('href', '#total-calls');
			};
		};
	};

	if (parseInt(totalCalls) > 0) {
		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_total_calls/',
			type: 'GET'
		});

		ajaxRequest.done(getTotalCallsResponse);
		ajaxRequest.fail(failedResponse);
	};	
};

var getNextTotalCalls = function(e) {
	e.preventDefault();

	if (checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_total_calls/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(nextTotalCallsResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getPrevTotalCalls = function(e) {
	e.preventDefault();

	if (checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/agent_dashboard/get_total_calls/',
		  type: 'GET',
		  data: { offset_counter: offsetCounter, end: endButton, button_clicked: true },
		  dataType: 'json'
		});

		ajaxRequest.done(prevTotalCallsResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

///////////////////////////////////////

var bindEventsAgentDashboard = function() {
	// $('#agents-online-button').on('click', getOnlineAgentsInformation);
	// $('#agents-on-call-button').on('click', getOnlineAgentsInformation);
	// $('#agents-idle-button').on('click', getOnlineAgentsInformation);
	$('.agents-online .btn-group .prev').on('click', getPrevOnlineAgentsInformation);
	$('.agents-online .btn-group .next').on('click', getNextOnlineAgentsInformation);
	$('.agents-online .btn-group .first').on('click', getPrevOnlineAgentsInformation);
	$('.agents-online .btn-group .last').on('click', getNextOnlineAgentsInformation);		

	$('#outbound-calls-in-queue-button').on('click', getOutboundCallsInQueue);
	$('.outbound-calls-in-queue .btn-group .prev').on('click', getPrevOutboundCallsInQueue);
	$('.outbound-calls-in-queue .btn-group .next').on('click', getNextOutboundCallsInQueue);
	$('.outbound-calls-in-queue .btn-group .first').on('click', getPrevOutboundCallsInQueue);
	$('.outbound-calls-in-queue .btn-group .last').on('click', getNextOutboundCallsInQueue);		

	$('#inbound-calls-waiting-button').on('click', getInboundCallsWaiting);
	$('.inbound-calls-waiting .btn-group .prev').on('click', getPrevInboundCallsWaiting);
	$('.inbound-calls-waiting .btn-group .next').on('click', getNextInboundCallsWaiting);
	$('.inbound-calls-waiting .btn-group .first').on('click', getPrevInboundCallsWaiting);
	$('.inbound-calls-waiting .btn-group .last').on('click', getNextInboundCallsWaiting);	

	$('#total-calls-button').on('click', getTotalCalls);
	$('.total-calls .btn-group .prev').on('click', getPrevTotalCalls);
	$('.total-calls .btn-group .next').on('click', getNextTotalCalls);
	$('.total-calls .btn-group .first').on('click', getPrevTotalCalls);
	$('.total-calls .btn-group .last').on('click', getNextTotalCalls);		
};

$(document).ready(function() {
	bindEventsAgentDashboard();
	// setUpAverageHoldTimeClock();
	// setUpLongestHoldTimeClock();
	// setUpBoxColors();
});	