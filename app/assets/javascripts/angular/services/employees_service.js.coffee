surveyApp.factory 'EmployeesService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  destroyEmployee: $resource "/destroy_employee.json", {}, query: { method: 'GET', isArray: false }

  getEmployees: $resource "/get_employees.json", {}, query: { method: 'GET', isArray: false }

]