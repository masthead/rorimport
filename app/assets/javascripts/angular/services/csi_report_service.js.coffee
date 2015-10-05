surveyApp.factory 'CSIReportService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getSurveyAttempts: $resource "/get_campaign_customer_survey_attempts.json", {}, query: { method: 'GET', isArray: false }

]