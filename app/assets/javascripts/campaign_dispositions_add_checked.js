
var changeChecked = function(e) {
	e.preventDefault();
	if(this.hasAttribute("checked") === true) {
		this.removeAttribute("checked");
	}

	else {
		this.setAttribute("checked", "checked");
	};
};

var bindEventsAddChecked = function() {
	$('.campaign-dispositions[name="campaign[disposition_ids][]"]').on('change', changeChecked);
};

$(document).ready(function() {
	bindEventsAddChecked();
});	