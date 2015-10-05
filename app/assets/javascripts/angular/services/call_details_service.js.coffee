surveyApp.factory 'CallDetailsService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getCallDetails: $resource "/get_call_details.json", {}, query: { method: 'GET', isArray: false }
]