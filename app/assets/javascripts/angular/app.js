var surveyApp = angular.module('surveyApp', 
	[
		'ngResource',
		'ui.bootstrap',
		'localytics.directives',
		'pusher-angular'
	]).config(function(datepickerConfig, datepickerPopupConfig) {
		datepickerConfig.showWeeks = false;
		datepickerPopupConfig.toggleWeeksText = null;
	});
	
surveyApp.run(function($rootScope, $templateCache) {
   $rootScope.$on('$viewContentLoaded', function() {
      $templateCache.removeAll();
   });
});