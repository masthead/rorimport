surveyApp.factory 'CampaignReportService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getAppointmentsSetCustomersData: $resource "/get_appointments_set_data.json", {}, query: { method: 'GET', isArray: false }

  getDispositionData: $resource "/get_disposition_data.json", {}, query: { method: 'GET', isArray: false }

  getNoContactCustomersData: $resource "/get_no_contact_customers_data.json", {}, query: { method: 'GET', isArray: false }

  getQuestionAnswerSurveyData: $resource "/get_question_answer_survey_data.json", {}, query: { method: 'GET', isArray: false }

  getRemainingCustomersData: $resource "/get_remaining_customers_data.json", {}, query: { method: 'GET', isArray: false }

  getSurveyAlertsData: $resource "/get_survey_alerts_data.json", {}, query: { method: 'GET', isArray: false }

  getTotalContactedCustomersData: $resource "/get_total_contacted_customers_data.json", {}, query: { method: 'GET', isArray: false }

  getTotalCustomersData: $resource "/get_total_customers_data.json", {}, query: { method: 'GET', isArray: false }

]