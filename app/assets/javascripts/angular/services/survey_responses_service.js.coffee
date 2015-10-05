surveyApp.factory 'SurveyResponsesService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  createSurveyResponse: $resource "/create_survey_response.json", {}, query: { method: 'GET', isArray: false }

  getSurveyCallDetails: $resource "/get_survey_call.json", {}, query: { method: 'GET', isArray: false }

  getSurveyResponses: $resource "/get_survey_responses.json", {}, query: { method: 'GET', isArray: false }
]