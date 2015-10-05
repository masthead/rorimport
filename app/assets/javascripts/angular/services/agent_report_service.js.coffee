surveyApp.factory 'AgentReportService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getCalls: $resource "/get_agent_calls.json", {}, query: { method: 'GET', isArray: false }

  emailCallRecording: $resource "/email_call_recording.json", {}, query: { method: 'GET', isArray: false }

  getSurveysCompleted: $resource "/get_agent_surveys_completed.json", {}, query: { method: 'GET', isArray: false }

  getTypeaheadValues: $resource "/get_agent_report_typeahead_values.json", {}, query: { method: 'GET', isArray: false }

]