
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

var noDealer = function(e) {
    var confirmationMessage = 'Please create and save the dealer first';

    console.log(confirmationMessage);

    alert(confirmationMessage);
};

$(function() {
    $(".dealer_required").click(function (e) {
        if (!parseInt($("#dealer_id").val()) > 0){
            this.removeAttribute("href")
            noDealer(e);
        };
    });
});

////////////////////////////////////////////////
///// Promotion ////////////////////////////////

var appendPromotion = function(promotionId, promotionTitle, promotionText, startDate, endDate) {
	return '<tr><td>' + promotionTitle + '</td><td><a data-toggle="modal" href="#promotion-'+ promotionId +'" type="button">' + promotionText + '</a></td><td>' + startDate + '</td><td>' + endDate + '</td><td><a data-toggle="modal" href="#promotion-'+ promotionId +'" type="button">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/promotions/' + promotionId + '" rel="nofollow">Destroy</a></td></tr>' 
};

var getPromotionResponse = function(data) {
	if (data.errors === false) {
		if (data.promotion.active === true) {
            gritterAdd("Successfully updated dealer promotions")
			$('#dealer_active_promotions').append(appendPromotion(data.promotion.id, data.promotion.title, data.promotion.text, data.promotion.start_date, data.promotion.end_date));	
		}

		else {
            gritterAdd("Successfully updated dealer promotions")
            $('#dealer_inactive_promotions').append(appendPromotion(data.promotion.id, data.promotion.title, data.promotion.text, data.promotion.start_date, data.promotion.end_date));
		};

		// Reset Form inputs
		$('.span .form-inputs .controls #promotion_promotion_title')[0].value = "";
		$('.span .form-inputs .controls #promotion_promotion_text')[0].value = "";

		$.datepicker._clearDate($('.span .form-inputs .controls #promotion_start_date')[0]);
		$.datepicker._clearDate($('.span .form-inputs .controls #promotion_end_date')[0]);
	};
};

var createPromotion = function(e) {
	e.preventDefault();
	var dealerId = $('#promotion_dealer_id')[0].value;
	var promotionTitle = $('.span .form-inputs .controls #promotion_promotion_title')[0].value;
	var promotionText = $('.span .form-inputs .controls #promotion_promotion_text')[0].value;
	var startDate = $('.span .form-inputs .controls #promotion_start_date')[0].value;
	var endDate = $('.span .form-inputs .controls #promotion_end_date')[0].value;

	if (dealerId && promotionTitle && promotionText && startDate && endDate) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_promotion',
			type: "POST",
			data: { promotion_title: promotionTitle, promotion_text: promotionText, start_date: startDate, end_date: endDate },
			dataType: 'json'
		});

		ajaxRequest.done(getPromotionResponse.bind(this));
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }
};

////////////////////////////////////////////////
///// User /////////////////////////////////////

var appendUser = function(userFullName, userEmail, userId) {
	return '<tr><td>' + userFullName + '</td><td>' + userEmail + '</td><td><a href="/users/' + userId + '/edit">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/users/' + userId + '" rel="nofollow">Destroy</a></td></tr>';
};

var getUserResponse = function(data) {
	if (data.errors === false) {
        gritterAdd("Dealer updated successfully")
        $('#dealer_users').append(appendUser(data.user.full_name, data.user.email, data.user.user_id))
	};
};

var createUser = function(e) {
	e.preventDefault();

	var dealerId = $('#user_dealer_id')[0].value;
	var firstName = $('#user_first_name')[0].value;
	var lastName = $('#user_last_name')[0].value;
	var userEmail = $('#user_email')[0].value;
	var phoneNumber = $('#user_phone_number_1')[0].value;

	if (firstName && lastName && userEmail && phoneNumber) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_user/',
			type: 'POST',
			data: { first_name: firstName, last_name: lastName, email: userEmail, phone_number_1: phoneNumber },
			dataType: 'json'
		});

		ajaxRequest.done(getUserResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }
};

////////////////////////////////////////////////
///// Department ///////////////////////////////

var appendDepartment = function(departmentId, departmentName, phoneNumber) {
	return '<tr><td>' + departmentName + '</td><td><a href="/departments/' + departmentId + '/edit">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/departments/' + departmentId + '" rel="nofollow">Destroy</a></td></tr>';
};

var getNewDepartmentReponse = function(data) {
	if (data.errors === false) {
        gritterAdd("Dealer updated successfully")

        $('#dealer_departments').append(appendDepartment(data.department.id, data.department.name, data.department.phone_number));
	
		$('#department_department_name')[0].value = "";
		$('#department_phone_number')[0].value = "";
	};
};

var createDepartment = function(e) {
	e.preventDefault();
	var dealerId = $('#department_dealer_id')[0].value;
	var departmentName = $('#department_department_name')[0].value;
	var phoneNumber = $('#department_phone_number')[0].value;

	if (departmentName) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_department/',
			type: "POST",
			data: { department_name: departmentName, phone_number: phoneNumber },
			dataType: 'json'
		});

		ajaxRequest.done(getNewDepartmentReponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    };
}

////////////////////////////////////////////////
///// Employee /////////////////////////////////

var appendEmployee = function(employeeId, employeeName, dmsKey, contactNotifications) {
	return '<tr><td>' + employeeName + '</td><td>' + dmsKey + '</td><td>' + contactNotifications + '</td><td><a href="/employees/' + employeeId + '">Show</a></td><td><a href="/employees/' + employeeId + '/edit">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/employees/' + employeeId + '" rel="nofollow">Destroy</a></td></tr>';
};

var getNewEmployeeResponse = function(data) {
	if(data.errors === false) {
        gritterAdd("Dealer updated successfully")

        $('#dealer_employees').append(appendEmployee(data.employee.id, data.employee.name, data.employee.dms_key, data.employee.contact_notifications));
	
		// Reset Input Form
		$('#employee_user_id')[0].value = "";
		$('#employee_job_title_id')[0].value = "";
		$('#employee_department_id')[0].value = "";
		$("select").trigger("chosen:updated");

		$('#employee_dms_key')[0].value = "";
		$('#employee_contact_notifications')[0].checked = false;
	};
};

var createNewEmployee = function(e) {
	e.preventDefault();
	var dealerId = $('#employee_dealer_id')[0].value;
	var userId = $('#employee_user_id')[0].value;
	var jobTitleId = $('#employee_job_title_id')[0].value;
	var departmentId = $('#employee_department_id')[0].value;
	var dmsKey = $('#employee_dms_key')[0].value;
	var contactNotifications = $('#employee_contact_notifications')[0].checked;

	if (dealerId && userId && jobTitleId) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_employee/',
			type: 'POST',
			data: { user_id: userId, job_title_id: jobTitleId, department_id: departmentId, dms_key: dmsKey, contact_notifications: contactNotifications },
			dataType: 'json'
		});

		ajaxRequest.done(getNewEmployeeResponse.bind(this));
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }
};

////////////////////////////////////////////////
///// Call Type ////////////////////////////////

var appendCallType = function(callTypeName, price, dealerCallTypeId) {
	return '<tr><td>' + callTypeName + '</td><td>' + price + '</td><td><a href="/dealer_call_types/' + dealerCallTypeId + '/edit">Edit</a></td><td><a data-confirm="Are you sure?" data-method="delete" href="/dealer_call_types/' + dealerCallTypeId + '" rel="nofollow">Destroy</a></td></tr>';
};

var getCallTypeResponse = function(data) {
	if (data.errors === false) {
        gritterAdd("Dealer updated successfully")

        $('#dealer_call_types').append(appendCallType(data.dealer_call_type.call_type, data.dealer_call_type.price, data.dealer_call_type.dealer_call_type_id))
	};	
};

var createCallType = function(e) {
	e.preventDefault();

	var dealerId = $('#dealer_call_type_dealer_id')[0].value;
	var callTypeId = $('#dealer_call_type_call_type_id')[0].value;
	var price = $('#dealer_call_type_price')[0].value;

	if (dealerId && callTypeId) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_call_type/',
			type: 'POST',
			data: { call_type_id: callTypeId, price: price },
			dataType: 'json'
		});

		ajaxRequest.done(getCallTypeResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }

};

////////////////////////////////////////////////
///// Special Instruction //////////////////////

var appendSpecialInstruction = function(typeName, instructionText, specialInstructionId) {
	return '<tr><td>' + typeName + '</td><td>' + instructionText + '</td><td><a href="/special_instructions/' + specialInstructionId + '/edit">Edit</td><td><a data-confirm="Are you sure?" data-method="delete" href="/special_instructions/' + specialInstructionId + '" rel="nofollow">Destroy</a></td></tr>'
};

var getSpecialInstructionResponse = function(data) {
	if (data.errors === false) {
        gritterAdd("Dealer updated successfully")

        $('#dealer_special_instructions').append(appendSpecialInstruction(data.special_instruction.special_instruction_type_name, data.special_instruction.instruction_text, data.special_instruction.special_instruction_id));
	}
};

var createSpecialInstruction = function(e) {
	e.preventDefault();

	var dealerId = $('#special_instruction_dealer_id')[0].value;
	var specialInstructionTypeId = $('.span .form-inputs .controls #special_instruction_special_instruction_type_id')[0].value;
	var instructionText = $('.span .form-inputs .controls #special_instruction_instruction_text')[0].value;

	if (dealerId && specialInstructionTypeId) {
        ajaxLoader("body");
        var ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/create_special_instruction/',
			type: 'POST',
			data: { special_instruction_type_id: specialInstructionTypeId, instruction_text: instructionText },
			dataType: 'json'
		});

		ajaxRequest.done(getSpecialInstructionResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }
};

////////////////////////////////////////////////
///// Dealer Update ////////////////////////////

var getDealerParams = function() {
	var unsortedParams = $('.update-dealer-params');

	dealerParams = {}
	for (var i = 0; i < unsortedParams.length; i++) {
		dealerParams[unsortedParams[i].id.split('_').slice(1).join('_')] = unsortedParams[i].value;
	};

	return dealerParams;
};

var getUpdateDealerResponse = function(data) {
	if (data.errors === false) {
        gritterAdd("Dealer updated successfully")

        console.log("Successful");
	}
};

var updateDealer = function(e) {
	e.preventDefault();

	var dealerParams = getDealerParams();
	var dealerId = $('#dealer_id')[0].value;

	if (dealerId) {
        ajaxLoader("body");
        ajaxRequest = $.ajax({
			url: '/dealers/' + dealerId + '/update_dealer_info/',
			type: 'PUT',
			data: { dealer: dealerParams },
			dataType: 'json'
		});

		ajaxRequest.done(getUpdateDealerResponse);
		ajaxRequest.fail(failedResponse);
        return $(".ajax_overlay").first().fadeOut();

    }
};

////////////////////////////////////////////////

$(document).ready(function() {
	bindEventsDealers();
});

var bindEventsDealers = function() {
	$('#dealer_update_employee').on('click', createNewEmployee);
	$('#dealer_update_department').on('click', createDepartment);
	$('#dealer_update_promotion').on('click', createPromotion);
	$('#dealer_update_call_type').on('click', createCallType);
	$('#dealer_update_special_instruction').on('click', createSpecialInstruction);
	$('#dealer_update_user').on('click', createUser);
	$('#dealer_update_general').on('click', updateDealer);
	$('#dealer_update_addresses').on('click', updateDealer);
	$('#dealer_update_phones').on('click', updateDealer);
	$('#dealer_update_settings').on('click', updateDealer);
};