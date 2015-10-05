
var appendDepartments = function(department) {
	return '<option value="' + department.id + '">' + department.department_name + '</option>';
};

var returnResponse = function(data) {
	if($('#employee_department_id')[0].children.length > 1) {
		while($('#employee_department_id')[0].children[0].nextSibling) {
			$('#employee_department_id')[0].children[0].nextSibling.remove();
		};
	};

  for(var i = 0; i < data.departments.length; i++) {
  	$('#employee_department_id').append(appendDepartments(data.departments[i]));
  };
};

var failedResponse = function() {
	console.log("Something went wrong!")
};

var sendDealerId = function(e) {
	e.preventDefault();
	var id = this.value
	if(id != "") {
		var ajaxRequest = $.ajax({
			url: '/employees/dealer/' + id,
			type: 'GET'
		});

		ajaxRequest.done(returnResponse.bind(this));
		ajaxRequest.fail(failedResponse);
	};
};

$(document).ready(function() {
	bindEvents();
});

var bindEvents = function() {
	$(".chzn-select#employee_dealer_id").on('change', sendDealerId);
};
