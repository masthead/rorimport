
var switchRoutes = function() {
	window.location = this.dataset["link"];
};

var bindEventsRowClickable = function() {
	$("tr[data-link]").on('click', switchRoutes);
};

$(document).ready(function() {
	bindEventsRowClickable();
});