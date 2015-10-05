surveyApp.factory 'CustomerSearchService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  searchCustomers: $resource "/customer_search_results.json", {}, query: { method: 'GET', isArray: false }

]