
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

var appendActivatableCampaigns = function(campaignName, startDate, endDate, active, dealerId, campaignId, inactive) {
	return '<tr><td><a href="/dealers/' + dealerId + '/campaigns/' + campaignId + '">' + campaignName + '</a></td><td>' + startDate + '</td><td>' + endDate + '</td><td>' + active + '</td><td><a data-method="post" href="/dealers/' + dealerId + '/campaigns/' + campaignId +'/make_active">' + inactive + '</a></td></tr>';
};

var getActivatableCampaignResponse = function(data) {
	for(var i = 0; i < data.activatable_length; i++) {
		$('.activatable-campaigns-body').append(appendActivatableCampaigns(data.campaign_names[i], data.start_dates[i], data.end_dates[i], data.actives[i], data.dealer_id, data.campaign_ids[i], data.inactives[i]));
	};
};

var prevActivatableCampaignResponse = function(data) {
	switchButtonsPrev.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
	$('.activatable-campaigns-body').children().remove();
	for(var i = 0; i < data.activatable_length; i++) {
		$('.activatable-campaigns-body').append(appendActivatableCampaigns(data.campaign_names[i], data.start_dates[i], data.end_dates[i], data.actives[i], data.dealer_id, data.campaign_ids[i], data.inactives[i]));
	};
};

var nextActivatableCampaignResponse = function(data) {
	switchButtonsNext.bind(this)(data.end_button, data.offset_counter.prev_counter, data.offset_counter.middle, data.offset_counter.next_counter);
	$('.activatable-campaigns-body').children().remove();
	for(var i = 0; i < data.activatable_length; i++) {
		$('.activatable-campaigns-body').append(appendActivatableCampaigns(data.campaign_names[i], data.start_dates[i], data.end_dates[i], data.actives[i], data.dealer_id, data.campaign_ids[i], data.inactives[i]));
	};	
};

var failedResponse = function() {
	console.log("Something went wrong!");
};

var getActivatableCampaigns = function(e) {
	e.preventDefault();
	var dealerId = this.id;
	var ajaxRequest = $.ajax({
		url: '/dealers/' + dealerId + '/campaigns_activatable',
		type: 'GET'
	});

	ajaxRequest.done(getActivatableCampaignResponse.bind(this));
	ajaxRequest.fail(failedResponse);
};

var getPrevActivatableCampaigns = function(e) {
	e.preventDefault();

	if(parseInt(this.id) >= 0) {
		var offsetCounter = this.id, endButton;
		var dealerId = $('.activatable')[0].id;		
		endButton = checkFirstEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/campaigns_activatable',
			type: 'GET',
			data: { offset_counter: offsetCounter, button_clicked: true, end: endButton },
			dataType: 'json'
		});

		ajaxRequest.done(prevActivatableCampaignResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

var getNextActivatableCampaigns = function(e) {
	e.preventDefault();
	
	if(parseInt(this.id) <= parseInt(this.parentElement.children[4].id)) {
		var offsetCounter = this.id, endButton;
		var dealerId = $('.activatable')[0].id;		
		endButton = checkLastEndButton.bind(this);

		var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/campaigns_activatable',
			type: 'GET',
			data: { offset_counter: offsetCounter, button_clicked: true, end: endButton },
			dataType: 'json'
		});

		ajaxRequest.done(nextActivatableCampaignResponse.bind(this));
		ajaxRequest.fail(failedResponse);	
	};
};

var bindEventsCampaignsActivatable = function() {
	$('.btn.btn-default.activatable').one('click', getActivatableCampaigns);
	$('.activatable-campaigns .btn-group .prev').on('click', getPrevActivatableCampaigns);
	$('.activatable-campaigns .btn-group .next').on('click', getNextActivatableCampaigns);
	$('.activatable-campaigns .btn-group .first').on('click', getPrevActivatableCampaigns);
	$('.activatable-campaigns .btn-group .last').on('click', getNextActivatableCampaigns);		
};

$(document).ready(function() {
	bindEventsCampaignsActivatable();
});	