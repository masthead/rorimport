surveyApp.factory 'CampaignDigestReportService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getAppointmentsSetCustomers: $resource "/get_appointments_set_digest_data.json", {}, query: { method: 'GET', isArray: false }

  getCustomersContacted: $resource "/get_customers_contacted.json", {}, query: { method: 'GET', isArray: false }

  getCustomersWithActivity: $resource "/get_customers_with_activity_data.json", {}, query: { method: 'GET', isArray: false }

  getHotAlertCustomers: $resource "/get_hot_alert_customers.json", {}, query: { method: 'GET', isArray: false }

]