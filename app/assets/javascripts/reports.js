
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

var getSurveyType = function(id) {
	if(parseInt(id[3]) % 1 === 0) {
		var surveyType = id[3];		
	}

	else {
		var surveyType = checkSurveyType(id[3]);
	};

	return surveyType;	
}

var checkSurveyType = function(surveyType) {
	if(surveyType === "contacted") {
		surveyType = "customers_contacted";
	};

	if(surveyType === "set") {
		surveyType = "appointments_set";
	};

	return surveyType;
};

var checkSurveyTypeResponseSide = function(id) {
	if(id === "contacted") {
		id = "customers_contacted";
	};

	if(id === "set") {
		id = "appointments_set";
	};

	return id; 
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

var formatEmployees = function(employees) {
	employeeString = ""
	if(employees.length > 0) {
		for(var i = 0; i < employees.length; i++) {
			employeeString = employeeString + '<p>' + employees[i] + '</p>';
		};
	}

	else {
		employeeString = '<p> </p>';
	};

	return employeeString;
};

var checkRightLimits = function() {
	return (this.classList.contains("next") && parseInt(this.id) <= parseInt(this.parentElement.children[4].id)) || (this.classList.contains("last") && parseInt(this.parentElement.children[3].id) <= parseInt(this.id));
};

var checkLeftLimits = function() {
	return ((this.classList.contains("prev") && parseInt(this.id) > 0)) || ((this.classList.contains("first") && parseInt(this.parentElement.children[1].id) > 0));
};

var changeDataToggle = function() {
	if (this.getAttribute("data-toggle") === "tooltip") {
		this.setAttribute("data-toggle", "modal");
	};
};

var failedResponse = function() {
	console.log("Something went wrong!");
};

var getHorrendous = function(id, recording) {
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

  return horrendous;
}

var getSurveyLink = function(dealerId, surveyId) {
	if (dealerId && parseInt(dealerId) > 0 && surveyId && parseInt(surveyId) > 0)
		return '<td><a href="/dealers/' + dealerId + '/surveys/' + surveyId + '">Survey Details</a></td>';

	else
		return '<td></td>';
}

/////////////////////////////////////////////////////
// CSI Report ///////////////////////////////////////

var appendCSISurveyAttemptsWithRecording = function(campaignName, date, disposition, phone_number, recording, id, dealerId, surveyId) {
  var horrendous = getHorrendous(id, recording);

	return '<tr><td>' + campaignName + '</td><td>' + date + '</td><td>' + disposition + '</td><td>' + phone_number + '</td><td>' + horrendous + '</td>' + getSurveyLink(dealerId, surveyId) + '</tr>';
}; 

var appendCSISurveyAttemptsWithoutRecording = function(campaignName, date, disposition, phone_number, dealerId, surveyId) {
	return '<tr><td>' + campaignName + '</td><td>' + date + '</td><td>' + disposition + '</td><td>' + phone_number + '</td><td></td>' + getSurveyLink(dealerId, surveyId) + '</tr>';
};

var getCampaignCustomerCSIAttemptsResponse = function(data) {
	if (data.errors === false) {
		campaign_customer_id = data.campaign_customer_id

		for (var i = 0; i < data.survey_attempts.length; i++) {
			if (data.survey_attempts[i].call_recording !== null) {
				$('#' + campaign_customer_id + '.csi_campaign_customers').append(appendCSISurveyAttemptsWithRecording(data.survey_attempts[i].campaign_name, data.survey_attempts[i].date, data.survey_attempts[i].disposition, data.survey_attempts[i].phone_number, data.survey_attempts[i].call_recording, data.campaign_customer_id, data.survey_attempts[i].dealer_id, data.survey_attempts[i].survey_id));
			}

			else {
				$('#' + campaign_customer_id + '.csi_campaign_customers').append(appendCSISurveyAttemptsWithoutRecording(data.survey_attempts[i].campaign_name, data.survey_attempts[i].date, data.survey_attempts[i].disposition, data.survey_attempts[i].phone_number, data.survey_attempts[i].dealer_id, data.survey_attempts[i].survey_id));
			}
		}
	}
}

var getCampaignCustomerCSIAttempts = function(data) {
	var campaign_customer_id = this.id;

	if (campaign_customer_id && parseInt(campaign_customer_id) > 0) {
		var ajaxRequest = $.ajax({
			url: '/campaign_customer_attempts/',
			type: 'GET',
			data: { campaign_customer_id: campaign_customer_id },
			dataType: 'json'
		});

		ajaxRequest.done(getCampaignCustomerCSIAttemptsResponse);
		ajaxRequest.fail(failedResponse);
	}
}

/////////////////////////////////////////////////////
// Service Transactions /////////////////////////////

var appendServices = function(dealerId, serviceId, roNumber, customerName, appointmentDate, roDate, roAmount) {
	return '<tr><td><a href="/dealers/' + dealerId + '/services/' + serviceId + '">' + roNumber + '</a></td><td>' + customerName + '</td><td>' + appointmentDate + '</td><td>' + roDate + '</td><td>' + roAmount + '</td></tr>';
};

var getServiceTransactionsResponse = function(data) {
	if (data.error === false) {
		for(var i = 0; i < data.service_transactions_length; i++) {
			$('#' + data.transaction_type + '.services').append(appendServices(data.dealer_id, data.service_ids[i], data.ronumbers[i], data.customer_names[i], data.appointment_dates[i], data.rodates[i], data.roamounts[i]));
		};
	};
};

var nextServiceTransactionsResponse = function(data) {
	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + data.transaction_type + '.services').children().remove();

		for(var i = 0; i < data.service_transactions_length; i++) {
			$('#' + data.transaction_type + '.services').append(appendServices(data.dealer_id, data.service_ids[i], data.ronumbers[i], data.customer_names[i], data.appointment_dates[i], data.rodates[i], data.roamounts[i]));
		};
	}

	else {
		$('#' + data.transaction_type + '.services').children().remove();
		$('#' + data.transaction_type + '.services').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");;
	}
};

var prevServiceTransactionsResponse = function(data) {
	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + data.transaction_type + '.services').children().remove();

		for(var i = 0; i < data.service_transactions_length; i++) {
			$('#' + data.transaction_type + '.services').append(appendServices(data.dealer_id, data.service_ids[i], data.ronumbers[i], data.customer_names[i], data.appointment_dates[i], data.rodates[i], data.roamounts[i]));
		};
	}

	else {
		$('#' + data.call_type + '.services').children().remove();
		$('#' + data.call_type + '.services').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");;
	}
};

var getServiceTransactions = function(e) {
	e.preventDefault();
	changeDataToggle.bind(this)();

	var dealerId = $('#dealer_id')[0].value;
	var startDate = $('input[name=start_date]')[0].value;
	var endDate = $('input[name=end_date]')[0].value;

	var transactionType = this.getAttribute("href").split('_')[this.getAttribute("href").split('_').length - 1];
	var ajaxRequest = $.ajax({
		url: '/report/get_total_transactions/',
		type: 'GET',
		data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, transaction_type: transactionType },
		dataType: 'json'
	});

	ajaxRequest.done(getServiceTransactionsResponse);
	ajaxRequest.fail(failedResponse);
};

var getNextServiceTransactions = function(e) {
	e.preventDefault();

	if (checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkLastEndButton.bind(this);
	  var dealerId = $('#dealer_id')[0].value;
	  var startDate = $('input[name=start_date]')[0].value;
	  var endDate = $('input[name=end_date]')[0].value;
	  var transactionType = $('.fade.modal.service-transactions.in')[0].id.split('_')[$('.fade.modal.service-transactions.in')[0].id.split('_').length - 1];

		var ajaxRequest = $.ajax({
			url: '/report/get_total_transactions/',
		  type: 'GET',
		  data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, offset_counter: offsetCounter, end: endButton, button_clicked: true, transaction_type: transactionType },
		  dataType: 'json'
		});

		ajaxRequest.done(nextServiceTransactionsResponse.bind(this));
		ajaxRequest.fail(failedResponse);

	};
};

var getPrevServiceTransactions = function(e) {
	e.preventDefault();

	if (checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);
		var dealerId = $('#dealer_id')[0].value;
	  var startDate = $('input[name=start_date]')[0].value;
	  var endDate = $('input[name=end_date]')[0].value;
	  var transactionType = $('.fade.modal.service-transactions.in')[0].id.split('_')[$('.fade.modal.service-transactions.in')[0].id.split('_').length - 1];

		var ajaxRequest = $.ajax({
			url: '/report/get_total_transactions/',
		  type: 'GET',
		  data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, offset_counter: offsetCounter, end: endButton, button_clicked: true, transaction_type: transactionType },
		  dataType: 'json'
		});

		ajaxRequest.done(prevServiceTransactionsResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};

};

/////////////////////////////////////////////////////
// Total Calls //////////////////////////////////////

var appendCallRecordsNoUrl = function(callEntryDate, callStatus, callAgent, callPhoneNumber) {
	return '<tr><td>' + callEntryDate + '</td><td>' + callStatus + '</td><td>' + callAgent + '</td><td>' + callPhoneNumber + '</td><td></td></tr>';
};

var appendCallRecords = function(callEntryDate, callStatus, callAgent, callPhoneNumber, recordingUrl) {
	return '<tr><td>' + callEntryDate + '</td><td>' + callStatus + '</td><td>' + callAgent + '</td><td>' + callPhoneNumber + '</td><td><a href="' + recordingUrl + '">Download File</a></td></tr>';
};

var getCallRecordsResponse = function(data) {
	if (data.error === false) {
		for(var i = 0; i < data.call_records_length; i++) {
			if (data.recording_urls[i] !== "") {
				$('#' + data.call_type + '.call-records').append(appendCallRecords(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i], data.recording_urls[i]));
			}

			else {
				$('#' + data.call_type + '.call-records').append(appendCallRecordsNoUrl(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i]));
			};
		};
	};
};

var prevCallRecordsResponse = function(data) {
	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + data.call_type + '.call-records').children().remove();

		for(var i = 0; i < data.call_records_length; i++) {
			if (data.recording_urls[i] !== "") {
				$('#' + data.call_type + '.call-records').append(appendCallRecords(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i], data.recording_urls[i]));
			}

			else {
				$('#' + data.call_type + '.call-records').append(appendCallRecordsNoUrl(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i]));
			};
		};
	}

	else {
		$('#' + data.call_type + '.call-records').children().remove();
		$('#' + data.call_type + '.call-records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");;
	}
};

var nextCallRecordsResponse = function(data) {
	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + data.call_type + '.call-records').children().remove();

		for(var i = 0; i < data.call_records_length; i++) {
			if (data.recording_urls[i] !== "") {
				$('#' + data.call_type + '.call-records').append(appendCallRecords(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i], data.recording_urls[i]));
			}

			else {
				$('#' + data.call_type + '.call-records').append(appendCallRecordsNoUrl(data.call_entry_dates[i], data.call_statuses[i], data.call_agents[i], data.call_phone_numbers[i]));
			};
		};
	}

	else {
		$('#' + data.call_type + '.call-records').children().remove();
		$('#' + data.call_type + '.call-records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");;
	}
};

var getCallRecords = function(e) {
	e.preventDefault();
	changeDataToggle.bind(this)();

	var dealerId = $('#dealer_id')[0].value;
	var startDate = $('input[name=start_date]')[0].value;
	var endDate = $('input[name=end_date]')[0].value;

	var callType = this.getAttribute("href").split('_')[this.getAttribute("href").split('_').length - 1];

	var ajaxRequest = $.ajax({
		url: '/report/get_total_calls/',
		type: 'GET',
		data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, call_type: callType },
		dataType: 'json'
	});

	ajaxRequest.done(getCallRecordsResponse);
	ajaxRequest.fail(failedResponse);
};

var getPrevCallRecords = function(e) {
	e.preventDefault();

	if (checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkFirstEndButton.bind(this);
		var dealerId = $('#dealer_id')[0].value;
	  var startDate = $('input[name=start_date]')[0].value;
	  var endDate = $('input[name=end_date]')[0].value;
	  var callType = $('.fade.modal.total-calls.in')[0].id.split('_')[$('.fade.modal.total-calls.in')[0].id.split('_').length - 1];

		var ajaxRequest = $.ajax({
			url: '/report/get_total_calls/',
		  type: 'GET',
		  data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, offset_counter: offsetCounter, end: endButton, button_clicked: true, call_type: callType },
		  dataType: 'json'
		});

		ajaxRequest.done(prevCallRecordsResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getNextCallRecords = function(e) {
	e.preventDefault();

	if (checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton = checkLastEndButton.bind(this);
	  var dealerId = $('#dealer_id')[0].value;
	  var startDate = $('input[name=start_date]')[0].value;
	  var endDate = $('input[name=end_date]')[0].value;
	  var callType = $('.fade.modal.total-calls.in')[0].id.split('_')[$('.fade.modal.total-calls.in')[0].id.split('_').length - 1];

		var ajaxRequest = $.ajax({
			url: '/report/get_total_calls/',
		  type: 'GET',
		  data: { dealer_id: dealerId, start_date: startDate, end_date: endDate, offset_counter: offsetCounter, end: endButton, button_clicked: true, call_type: callType },
		  dataType: 'json'
		});

		ajaxRequest.done(nextCallRecordsResponse.bind(this));
		ajaxRequest.fail(failedResponse);

	};
};

/////////////////////////////////////////////////////
// Customers ////////////////////////////////////////

var appendCampaignCustomers = function(dealerId, customerId, fullName, homePhone, workPhone, cellPhone, lastAttemptTime, attempts, surveyId) {
	return '<tr><td><a href="/dealers/' + dealerId + '/customers/' + customerId + '">' + fullName + '</a></td><td>' + homePhone + '</td><td>' + workPhone + '</td><td>' + cellPhone + '</td><td>' + lastAttemptTime + '</td><td>' + attempts + '</td><td><a href="/dealers/' + dealerId + '/surveys/' + surveyId + '">Survey Details</a></td></tr>';
};

var appendCampaignCustomersNoCurrentSurvey = function(dealerId, customerId, fullName, homePhone, workPhone, cellPhone, lastAttemptTime, attempts) {
	return '<tr><td><a href="/dealers/' + dealerId + '/customers/' + customerId + '">' + fullName + '</a></td><td>' + homePhone + '</td><td>' + workPhone + '</td><td>' + cellPhone + '</td><td>' + lastAttemptTime + '</td><td>' + attempts + '</td><td>n/a</td></tr>';
};

var appendCampaignCustomersNoSurveys = function(dealerId, customerId, fullName, homePhone, workPhone, cellPhone, lastAttemptTime, attempts) {
	return '<tr><td><a href="/dealers/' + dealerId + '/customers/' + customerId + '">' + fullName + '</a></td><td>' + homePhone + '</td><td>' + workPhone + '</td><td>' + cellPhone + '</td><td>' + lastAttemptTime + '</td><td>' + attempts + '</td></tr>';
};

var loopThroughCustomers = function(data, campaignCustomerTypeId) {
	for(var i = 0; i < data.campaign_customers_length; i++) {
		if (campaignCustomerTypeId === "1") {
			if (data.completed_surveys[i] && data.completed_surveys[i] % 1 === 0) {
				$('#' + campaignCustomerTypeId + '.campaign_customers').append(appendCampaignCustomers(data.dealer_id, data.campaign_customer_ids[i], data.full_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.last_attempt_times[i], data.attempt_counts[i], data.completed_surveys[i]));	
			}

			else {
				$('#' + campaignCustomerTypeId + '.campaign_customers').append(appendCampaignCustomersNoCurrentSurvey(data.dealer_id, data.campaign_customer_ids[i], data.full_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.last_attempt_times[i], data.attempt_counts[i]));	
			}
		}

		else {
			$('#' + campaignCustomerTypeId + '.campaign_customers').append(appendCampaignCustomersNoSurveys(data.dealer_id, data.campaign_customer_ids[i], data.full_names[i], data.home_phones[i], data.work_phones[i], data.cell_phones[i], data.last_attempt_times[i], data.attempt_counts[i]));
		}
	};
};

var nextCustomerResponse = function(data) {
	var campaignCustomerTypeId = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];

	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + campaignCustomerTypeId + '.campaign_customers').children().remove();

		loopThroughCustomers(data, campaignCustomerTypeId);
	}

	else {
		$('#' + campaignCustomerTypeId + '.campaign_customers').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var prevCustomerResponse = function(data) {
	var campaignCustomerTypeId = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];

	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		
		$('#' + campaignCustomerTypeId + '.campaign_customers').children().remove();

		loopThroughCustomers(data, campaignCustomerTypeId);
	}

	else {
		$('#' + campaignCustomerTypeId + '.campaign_customers').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getCustomerResponse = function(data) {
	var campaignCustomerTypeId = this.id.split('_')[1];

	if(data.error === false) {
		loopThroughCustomers(data, campaignCustomerTypeId);
	}

	else {
		$('#' + campaignCustomerTypeId + '.campaign_customers').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");		
	}
};

var getCampaignCustomers = function(e) {
	e.preventDefault();
	changeDataToggle.bind(this)();
	var reportModel = window.location.href.split('?')[0].split('/')[window.location.href.split('?')[0].split('/').length-1];
	var campaignModel = this.id.split('_', 2)[0];
	var customerType = this.id.split('_', 2)[1];

	var ajaxRequest = $.ajax({
		url: "/report/campaign_customers/",
		type: "GET",
		data: { start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_id: $('#campaign_id option[selected]')[0].value.split('_')[0], customer_type: customerType, campaign_model: campaignModel, report_model: reportModel },
		dataType: 'json'
	});

	ajaxRequest.done(getCustomerResponse.bind(this));
	ajaxRequest.fail(failedResponse);
};

var getPrevCustomers = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {
		var reportModel = window.location.href.split('?')[0].split('/')[window.location.href.split('?')[0].split('/').length-1];		
		var offsetCounter = this.id, endButton;
		var campaignModel = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[0];
		var customerType = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];
		
		endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/campaign_customers/",
			type: "GET",
			data: { start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_id: $('#campaign_id option[selected]')[0].value, customer_type: customerType, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel, report_model: reportModel },
			dataType: 'json'
		});

		ajaxRequest.done(prevCustomerResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getNextCustomers = function(e) {
	e.preventDefault();

	if(checkRightLimits.bind(this)()) {
		var reportModel = window.location.href.split('?')[0].split('/')[window.location.href.split('?')[0].split('/').length-1];
		var offsetCounter = this.id, endButton;
		var campaignModel = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[0];
		var customerType = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];

		endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/campaign_customers/",
			type: "GET",
			data: { start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_id: $('#campaign_id option[selected]')[0].value, customer_type: customerType, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel, report_model: reportModel },
			dataType: 'json'
		});

		ajaxRequest.done(nextCustomerResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

/////////////////////////////////////////////////////
// Dispositions /////////////////////////////////////

var appendSurveyAttemptsWithRecording = function(firstName, lastName, date, recording, id) {
  var horrendous = getHorrendous(id, recording);

	return '<tr><td>' + firstName + '</td><td>' + lastName + '</td><td>' + date + '</td><td>' + horrendous + '</td>';
}; 

var appendSurveyAttemptsWithoutRecording = function(firstName, lastName, date) {
	return '<tr><td>' + firstName + '</td><td>' + lastName + '</td><td>' + date + '</td><td>n/a</td>';
};

var nextDispositionResponse = function(data) {
	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		var id = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];
		$('#' + id + '.dispositions').children().remove();

		for(var i = 0; i < data.survey_attempts_length; i++) {
			if(data.recordings[i] !== "") {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithRecording(data.first_names[i], data.last_names[i], data.dates[i], data.recordings[i], data.ids[i]));
			}
			else {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithoutRecording (data.first_names[i], data.last_names[i], data.dates[i]));	
			};
		};
	}

	else {
		$('#' + data.disposition_id + '.dispositions').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var prevDispositionResponse = function(data) {
	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		var id = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];
		$('#' + id + '.dispositions').children().remove();

		for(var i = 0; i < data.survey_attempts_length; i++) {
			if(data.recordings[i] !== "") {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithRecording(data.first_names[i], data.last_names[i], data.dates[i], data.recordings[i], data.ids[i]));
			}
			else {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithoutRecording (data.first_names[i], data.last_names[i], data.dates[i]));	
			};
		};	
	}

	else {
		$('#' + data.disposition_id + '.dispositions').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getDispositionResponse = function(data) {
	if(data.error === false) {
		for(var i = 0; i < data.survey_attempts_length; i++) {
			if(data.recordings[i] !== "") {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithRecording(data.first_names[i], data.last_names[i], data.dates[i], data.recordings[i], data.ids[i]));
			}
			else {
				$('#' + data.disposition_id + '.dispositions').append(appendSurveyAttemptsWithoutRecording (data.first_names[i], data.last_names[i], data.dates[i]));	
			};
		};
	}

	else {
		$('#' + data.disposition_id + '.dispositions').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getSurveyDispositions = function(e) {
	e.preventDefault();
	changeDataToggle.bind(this)();
	var campaignModel = this.id.split('_', 2)[0];
	var dispositionId = this.id.split('_', 2)[1];
	var ajaxRequest = $.ajax({
		url: "/report/survey_attempts/" + dispositionId,
		type: "GET",
		data: { campaign_id: $('#campaign_id option[selected]')[0].value.split('_')[0], start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_model: campaignModel },
		dataType: 'json'
	});

	ajaxRequest.done(getDispositionResponse);
	ajaxRequest.fail(failedResponse);
};

var getPrevDispositions = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignModel = $('.disposition')[0].id.split('_', 2)[0];		
		var dispositionId = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];
		endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/survey_attempts/" + dispositionId,
			type: "GET",
			data: { campaign_id: $('#campaign_id option[selected]')[0].value.split('_',2)[0], start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(prevDispositionResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
	}
};

var getNextDispositions = function(e) {
	e.preventDefault();
	if(checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignModel = $('.disposition')[0].id.split('_', 2)[0];
		var dispositionId = this.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.split('_', 3)[2];
		endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/survey_attempts/" + dispositionId,
			type: "GET",
			data: { campaign_id: $('#campaign_id option[selected]')[0].value.split('_',2)[0], start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(nextDispositionResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
	}
};

/////////////////////////////////////////////////////
// Surveys //////////////////////////////////////////

var appendSurveys = function(customerId, customer, surveyTemplate, completedDate, appointment, dealerId, surveyId) {
	return '<tr><td><a href="/dealers/' + dealerId + '/customers/' + customerId + '/edit">' + customer + '</a></td><td>' + surveyTemplate + '</td><td>' + completedDate + '</td><td>' + appointment + '</td><td><a href="/dealers/' + dealerId + '/surveys/' + surveyId +'">Survey Details</a></td></tr>'
};

var prevSurveyResponse = function(data) {
	var id = this.parentElement.id;		
	
	// id = checkSurveyTypeResponseSide(id);

	if (data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		$('#' + id + '.surveys').children().remove();
         console.log(data);
		for(var i = 0; i < data.surveys_length; i++) {
			$('#' + id + '.surveys').append(appendSurveys(data.customer_ids[i], data.customers[i], data.survey_templates[i], data.completed_dates[i], data.appointments[i], data.dealer_id, data.survey_ids[i]));
		};
	}

	else {
		$('#' + id + '.surveys').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var nextSurveyResponse = function(data) {
	var id = this.parentElement.id;		

	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		
		$('#' + id + '.surveys').children().remove();

		for(var i = 0; i < data.surveys_length; i++) {
			$('#' + id + '.surveys').append(appendSurveys(data.customer_ids[i], data.customers[i], data.survey_templates[i], data.completed_dates[i], data.appointments[i], data.dealer_id, data.survey_ids[i]));
		};
	}

	else {
		$('#' + id + '.surveys').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getSurveyResponse = function(data) {
	var id;

	if(this.id.split('_').length === 3) {
		id = this.id.split('_')[1] + '_' + this.id.split('_')[2];
	}

	else {
		id = this.id;
	};

	if(data.error === false) {
		for(var i = 0; i < data.surveys_length; i++) {
			$('#' + id + '.surveys').append(appendSurveys(data.customer_ids[i], data.customers[i], data.survey_templates[i], data.completed_dates[i], data.appointments[i], data.dealer_id, data.survey_ids[i]));
		};
	}

	else {
		$('#' + id + '.surveys').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getCampaignSurveys = function(e) {
	e.preventDefault();

	changeDataToggle.bind(this)();
	var campaignId, surveyType, campaignModel;

	if(this.id.split('_').length === 3) {
		surveyType = this.id.split('_', 3)[1] + '_' + this.id.split('_', 3)[2];
		campaignId = $('#campaign_id option[selected]')[0].value.split('_')[0];
		campaignModel = this.id.split('_')[0];
	}

	else {
		surveyType = this.id.split('_', 2)[1];
		campaignId = this.id.split('_')[0];
		campaignModel = "campaign"
	}

	var ajaxRequest = $.ajax({
		url: "/report/surveys/",
		type: "GET",
		data: { survey_type: surveyType, campaign_id: campaignId, start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_model: campaignModel },
		dataType: 'json'
	});

	ajaxRequest.done(getSurveyResponse.bind(this));
	ajaxRequest.fail(failedResponse);
};

var getPrevSurveys = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {

		var offsetCounter = this.id, endButton, surveyType, campaignId, campaignModel;

		if(this.parentElement.id === "customers_contacted" || this.parentElement.id === "appointments_set") {
			surveyType = this.parentElement.id;
			campaignModel = $('.survey')[0].id.split('_')[0];
			campaignId = $('#campaign_id option[selected]')[0].value.split('_',2)[0];
		}

		else {
			campaignModel = "campaign";
			campaignId = this.parentElement.id.split('_')[0];
			surveyType = this.parentElement.id.split('_')[1];			
		}
		
		endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/surveys/",
			type: "GET",
			data: { survey_type: surveyType, campaign_id: campaignId, start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(prevSurveyResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	}
};

var getNextSurveys = function(e) {
	e.preventDefault();

	if(checkRightLimits.bind(this)()) {
		
		var offsetCounter = this.id, endButton, campaignModel, campaignId, surveyType;

		if(this.parentElement.id === "customers_contacted" || this.parentElement.id === "appointments_set") {
			surveyType = this.parentElement.id;
			campaignModel = $('.survey')[0].id.split('_')[0];
			campaignId = $('#campaign_id option[selected]')[0].value.split('_',2)[0];
		}

		else {
			campaignModel = "campaign";
			campaignId = this.parentElement.id.split('_')[0];
			surveyType = this.parentElement.id.split('_')[1];			
		}

		endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: "/report/surveys/",
			type: "GET",
			data: { survey_type: surveyType, campaign_id: campaignId, start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(nextSurveyResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
	};
};

/////////////////////////////////////////////////////
// Alerts ///////////////////////////////////////////

var appendSurveyAlerts = function(user, sent, alertType, employees, alertText) {
	return '<tr><td>' + user + '</td><td>' + sent + '</td><td>' + alertType + '</td><td>' + formatEmployees(employees) + '</td><td>' + alertText + '</td>';
};

var prevAlertResponse = function(data) {

	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		
		for(var i = 1; i < $('.survey_alerts').children().length; i++) {
			$('.survey_alerts').children()[i].remove();
		};

		for(var i = 0; i < data.survey_alert_length; i++) {
			$('.survey_alerts').append(appendSurveyAlerts(data.users[i], data.sents[i], data.alert_types[i], data.employees[i], data.alert_texts[i]));
		};	
	}

	else {
		$('.survey_alerts').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var nextAlertResponse = function(data) {

	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);

		for(var i = 1; i < $('.survey_alerts').children().length; i++) {
			$('.survey_alerts').children()[i].remove();
		};

		for(var i = 0; i < data.survey_alert_length; i++) {
			$('.survey_alerts').append(appendSurveyAlerts(data.users[i], data.sents[i], data.alert_types[i], data.employees[i], data.alert_texts[i]));
		};
	}

	else {
		$('.survey_alerts').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");	
	};
};

var getSurveyAlertResponse = function(data) {
	if(data.error === false) {
		for(var i = 0; i < data.survey_alert_length; i++) {
			$('.survey_alerts').append(appendSurveyAlerts(data.users[i], data.sents[i], data.alert_types[i], data.employees[i], data.alert_texts[i]));
		};
	}

	else {
		$('.survey_alerts').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getSurveyAlerts = function(e) {
	e.preventDefault();
	changeDataToggle.bind(this)();
	var campaignModel = this.id;
	var ajaxRequest = $.ajax({
		url: "/report/survey_alerts/",
		type: "GET",
		data: { campaign_id: $('#campaign_id option[selected]')[0].value.split('_')[0], start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, campaign_model: campaignModel },
		dataType: 'json'
	});

	ajaxRequest.done(getSurveyAlertResponse);
	ajaxRequest.fail(failedResponse);
};

var getPrevAlerts = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignModel = $('.survey_alert')[0].id;
		endButton = checkFirstEndButton.bind(this);
		var ajaxRequest = $.ajax({
			url: "/report/survey_alerts/",
			type: "GET",
			data: { campaign_id: $('#campaign_id option[selected]')[0].value, start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(prevAlertResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
	}
};

var getNextAlerts = function(e) {
	e.preventDefault();

	if(checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignModel = $('.survey_alert')[0].id;
		endButton = checkLastEndButton.bind(this);
		var ajaxRequest = $.ajax({
			url: "/report/survey_alerts/",
			type: "GET",
			data: { campaign_id: $('#campaign_id option[selected]')[0].value, start_date: $('input[name=start_date]')[0].value, end_date: $('input[name=end_date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, campaign_model: campaignModel },
			dataType: 'json'
		});

		ajaxRequest.done(nextAlertResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
		
	}
};

/////////////////////////////////////////////////////
// Dealer Records ///////////////////////////////////

var appendCustomerRecords = function(customerName, customerId, dealerId) {
	return '<tr><td>' + customerName + '</td><td><a href="/dealers/' + dealerId + '/customers/' + customerId + '">View Details</td></tr>';
};

var getRecordType = function(classNames) {
	var recordType;

	for(var i = 0; i < classNames.length; i++) {
		if (classNames[i] !== 'btn' && classNames[i] != 'btn-link' && classNames[i] != 'in' && classNames[i] != 'fade' && classNames[i] != 'modal') {
			recordType = classNames[i];	
		}
	}

	return recordType;
};

var prevDealerRecordResponse = function(data) {

	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		$('#' + dealerId + '_' + recordType + '.dealer_records').children().remove();

		for(var i = 0; i < data.records_length; i++) {
			$('#' + dealerId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));
		};
	}

	else {
		$('#' + dealerId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");	
	};
};

var nextDealerRecordResponse = function(data) {

	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		$('#' + dealerId + '_' + recordType + '.dealer_records').children().remove();

		for(var i = 0; i < data.records_length; i++) {
			$('#' + dealerId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));
		};
	}

	else {
		$('#' + dealerId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");	
	};
};


var getDealerRecordsResponse = function(data) {
	if(data.error === false) {
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		for(var i = 0; i < data.records_length; i++) {
			$('#' + dealerId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));
		};
	}

	else {
		$('#' + dealerId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var getDealerRecords = function(e) {
	e.preventDefault();

	changeDataToggle.bind(this)();
	var dealerId = this.id;
	var recordType = getRecordType(this.className.split(' '));
	
	if (recordType) {
		var ajaxRequest = $.ajax({
			url: "/report/get_dealer_records/",
			type: "GET",
			data: { dealer_id: dealerId, date: $('input[name=date]')[0].value, record_type: recordType },
			dataType: 'json'
		});

		ajaxRequest.done(getDealerRecordsResponse);
		ajaxRequest.fail(failedResponse);
	}
};

var getPrevDealerRecords = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var dealerId = this.parentElement.id;
		var recordType = getRecordType(jQuery(this).closest('.modal')[0].className.split(' '));
		endButton = checkFirstEndButton.bind(this);

		if (recordType) {
			var ajaxRequest = $.ajax({
				url: "/report/get_dealer_records/",
				type: "GET",
				data: { dealer_id: dealerId, date: $('input[name=date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, record_type: recordType },
				dataType: 'json'
			});

			ajaxRequest.done(prevDealerRecordResponse.bind(this));
			ajaxRequest.fail(failedResponse);	
		}
	}
};

var getNextDealerRecords = function(e) {
	e.preventDefault();

	if(checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var dealerId = this.parentElement.id;
		var recordType = getRecordType(jQuery(this).closest('.modal')[0].className.split(' '));
		endButton = checkLastEndButton.bind(this);

		if (recordType) {
			var ajaxRequest = $.ajax({
				url: "/report/get_dealer_records/",
				type: "GET",
				data: { dealer_id: dealerId, date: $('input[name=date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, record_type: recordType },
				dataType: 'json'
			});

			ajaxRequest.done(nextDealerRecordResponse.bind(this));
			ajaxRequest.fail(failedResponse);	
		}
	}
};

/////////////////////////////////////////////////////
// Campaigns Records ////////////////////////////////

var appendCustomerIneligibleRecords = function(customerName, customerStatus) {
	return '<tr><td>' + customerName + '</td><td>' + customerStatus + '</td></tr>';
};

var getCampaignRecordsResponse = function(data) {
	if(data.error === false) {
		var campaignId = data.campaign_id;
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		for(var i = 0; i < data.records_length; i++) {
			if (recordType === "eligible-records" || recordType === "enrolled-records") {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));	
			}

			else {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerIneligibleRecords(data.customer_names[i], data.customer_statuses[i]));
			}
		};
	}

	else {
		$('#' + dealerId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");
	};
};

var prevCampaignRecordResponse = function(data) {

	if(data.error === false) {
		switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var campaignId = data.campaign_id;
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		$('#' + campaignId + '_' + recordType + '.dealer_records').children().remove();

		for(var i = 0; i < data.records_length; i++) {
			if (recordType === "eligible-records" || recordType === "enrolled-records") {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));	
			}

			else {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerIneligibleRecords(data.customer_names[i], data.customer_statuses[i]));
			}
		};
	}

	else {
		$('#' + campaignId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");	
	};
};

var nextCampaignRecordResponse = function(data) {

	if(data.error === false) {
		switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
		var campaignId = data.campaign_id;
		var dealerId = data.dealer_id;
		var recordType = data.record_type;

		$('#' + campaignId + '_' + recordType + '.dealer_records').children().remove();

		for(var i = 0; i < data.records_length; i++) {
			if (recordType === "eligible-records" || recordType === "enrolled-records") {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerRecords(data.customer_names[i], data.customer_ids[i], dealerId));	
			}

			else {
				$('#' + campaignId + '_' + recordType + '.dealer_records').append(appendCustomerIneligibleRecords(data.customer_names[i], data.customer_statuses[i]));
			}
		};
	}

	else {
		$('#' + campaignId + '_' + recordType + '.dealer_records').append("<tr><td>An Error Occurred. Please reload the browser. If the error persists, please contact DealerFocus today.</td></tr>");	
	};
};

var getCampaignRecords = function(e) {
	e.preventDefault();

	changeDataToggle.bind(this)();
	var campaignId = this.id;
	var recordType = getRecordType(this.className.split(' '));
	
	if (recordType) {
		var ajaxRequest = $.ajax({
			url: "/report/get_campaign_records/",
			type: "GET",
			data: { campaign_id: campaignId, date: $('input[name=date]')[0].value, record_type: recordType },
			dataType: 'json'
		});

		ajaxRequest.done(getCampaignRecordsResponse);
		ajaxRequest.fail(failedResponse);
	}
};

var getPrevCampaignRecords = function(e) {
	e.preventDefault();

	if(checkLeftLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignId = this.parentElement.id;
		var recordType = getRecordType(jQuery(this).closest('.modal')[0].className.split(' '));
		endButton = checkFirstEndButton.bind(this);

		if (recordType) {
			var ajaxRequest = $.ajax({
				url: "/report/get_campaign_records/",
				type: "GET",
				data: { campaign_id: campaignId, date: $('input[name=date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, record_type: recordType },
				dataType: 'json'
			});

			ajaxRequest.done(prevCampaignRecordResponse.bind(this));
			ajaxRequest.fail(failedResponse);	
		}
	}
};

var getNextCampaignRecords = function(e) {
	e.preventDefault();

	if(checkRightLimits.bind(this)()) {
		var offsetCounter = this.id, endButton;
		var campaignId = this.parentElement.id;
		var recordType = getRecordType(jQuery(this).closest('.modal')[0].className.split(' '));
		endButton = checkLastEndButton.bind(this);

		if (recordType) {
			var ajaxRequest = $.ajax({
				url: "/report/get_campaign_records/",
				type: "GET",
				data: { campaign_id: campaignId, date: $('input[name=date]')[0].value, offset_counter: offsetCounter, button_clicked: true, end: endButton, record_type: recordType },
				dataType: 'json'
			});

			ajaxRequest.done(nextCampaignRecordResponse.bind(this));
			ajaxRequest.fail(failedResponse);	
		}
	}
};

/////////////////////////////////////////////////////

var bindEventsReports = function() {
	$('.btn.btn-link.disposition').one('click', getSurveyDispositions);
	$('.dispositions .btn-group .prev').on('click', getPrevDispositions);
	$('.dispositions .btn-group .next').on('click', getNextDispositions);
	$('.dispositions .btn-group .first').on('click', getPrevDispositions);
	$('.dispositions .btn-group .last').on('click', getNextDispositions);	

	$('.btn.btn-link.campaign_customer').one('click', getCampaignCustomers);
	$('.campaign_customers .btn-group .prev').on('click', getPrevCustomers);
	$('.campaign_customers .btn-group .next').on('click', getNextCustomers);
	$('.campaign_customers .btn-group .first').on('click', getPrevCustomers);
	$('.campaign_customers .btn-group .last').on('click', getNextCustomers);

	$('.btn.btn-link.survey_alert').one('click', getSurveyAlerts);
	$('.survey_alerts .btn-group .prev').on('click', getPrevAlerts);
	$('.survey_alerts .btn-group .next').on('click', getNextAlerts);
	$('.survey_alerts .btn-group .first').on('click', getPrevAlerts);
	$('.survey_alerts .btn-group .last').on('click', getNextAlerts);

	$('.btn.btn-link.survey').one('click', getCampaignSurveys);
	$('.surveys .btn-group .prev').on('click', getPrevSurveys);
	$('.surveys .btn-group .next').on('click', getNextSurveys);
	$('.surveys .btn-group .first').on('click', getPrevSurveys);
	$('.surveys .btn-group .last').on('click', getNextSurveys);	

	$('.btn.btn-link.total-calls').one('click', getCallRecords);
	$('.total-calls .btn-group .prev').on('click', getPrevCallRecords);
	$('.total-calls .btn-group .next').on('click', getNextCallRecords);
	$('.total-calls .btn-group .first').on('click', getPrevCallRecords);
	$('.total-calls .btn-group .last').on('click', getNextCallRecords);	

	$('.btn.btn-link.service-transactions').one('click', getServiceTransactions);
	$('.service-transactions .btn-group .prev').on('click', getPrevServiceTransactions);
	$('.service-transactions .btn-group .next').on('click', getNextServiceTransactions);
	$('.service-transactions .btn-group .first').on('click', getPrevServiceTransactions);
	$('.service-transactions .btn-group .last').on('click', getNextServiceTransactions);

	$('.btn.btn-link.sales-records').one('click', getDealerRecords);
	$('.sales-records .btn-group .prev').on('click', getPrevDealerRecords);
	$('.sales-records .btn-group .next').on('click', getNextDealerRecords);
	$('.sales-records .btn-group .first').on('click', getPrevDealerRecords);
	$('.sales-records .btn-group .last').on('click', getNextDealerRecords);

	$('.btn.btn-link.services-records').one('click', getDealerRecords);
	$('.services-records .btn-group .prev').on('click', getPrevDealerRecords);
	$('.services-records .btn-group .next').on('click', getNextDealerRecords);
	$('.services-records .btn-group .first').on('click', getPrevDealerRecords);
	$('.services-records .btn-group .last').on('click', getNextDealerRecords);

	$('.btn.btn-link.appointments-records').one('click', getDealerRecords);
	$('.appointments-records .btn-group .prev').on('click', getPrevDealerRecords);
	$('.appointments-records .btn-group .next').on('click', getNextDealerRecords);
	$('.appointments-records .btn-group .first').on('click', getPrevDealerRecords);
	$('.appointments-records .btn-group .last').on('click', getNextDealerRecords);

	$('.btn.btn-link.eligible-records').one('click', getCampaignRecords);
	$('.eligible-records .btn-group .prev').on('click', getPrevCampaignRecords);
	$('.eligible-records .btn-group .next').on('click', getNextCampaignRecords);
	$('.eligible-records .btn-group .first').on('click', getPrevCampaignRecords);
	$('.eligible-records .btn-group .last').on('click', getNextCampaignRecords);

	$('.btn.btn-link.ineligible-records').one('click', getCampaignRecords);
	$('.ineligible-records .btn-group .prev').on('click', getPrevCampaignRecords);
	$('.ineligible-records .btn-group .next').on('click', getNextCampaignRecords);
	$('.ineligible-records .btn-group .first').on('click', getPrevCampaignRecords);
	$('.ineligible-records .btn-group .last').on('click', getNextCampaignRecords);

	$('.btn.btn-link.enrolled-records').one('click', getCampaignRecords);
	$('.enrolled-records .btn-group .prev').on('click', getPrevCampaignRecords);
	$('.enrolled-records .btn-group .next').on('click', getNextCampaignRecords);
	$('.enrolled-records .btn-group .first').on('click', getPrevCampaignRecords);
	$('.enrolled-records .btn-group .last').on('click', getNextCampaignRecords);

	$('.campaign_customer_csi_modal').one('click', getCampaignCustomerCSIAttempts);
};

$(document).ready(function() {
	// bindEventsReports();
});	
