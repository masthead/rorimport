surveyApp.factory 'DealersService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getDealers: $resource "/get_dealers.json", {}, query: { method: 'GET', isArray: false }

]