surveyApp.factory 'UsersService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getUsers: $resource "/get_users.json", {}, query: { method: 'GET', isArray: false }

]