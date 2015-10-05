surveyApp.controller 'EmployeesCtrl', ['$scope', '$http', 'EmployeesService', '$location', '$pusher', ($scope, $http, EmployeesService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initializeNewSearch()
    $scope.requestControl.getEmployees()

################################################################
############## Other Initializers ##############################

  initializeNewSearch = ->
    $scope.searchInput = {
      id: null

      user_full_name: null

      dealer_name: null
    }

  $scope.searchControl = {
    filteredUserFullName: ->
      angular.lowercase($scope.searchInput.user_full_name)

    filteredEmployeeId: ->
      $scope.searchInput.id

    filteredDealerName: ->
      angular.lowercase($scope.searchInput.dealer_name)

  }

  $scope.sortableControl = {

    sortedBy: 'users.last_name'

    user_last_name: 'ASC'

    dealer_name: 'DESC'

    job_title: 'DESC'

    department: 'DESC'

    dms_key: 'DESC'

    is_active: 'DESC'

    sortUserNames: ->
      this.sortedBy = 'users.last_name'
      if this.user_last_name == 'ASC' then this.user_last_name = 'DESC' else this.user_last_name = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.dealer_name = 'DESC'
      this.job_title = 'DESC'
      this.department = 'DESC'
      this.dms_key = 'DESC'
      this.is_active = 'DESC'

    sortDealerNames: ->
      this.sortedBy = 'dealers.dealer_name'
      if this.dealer_name == 'ASC' then this.dealer_name = 'DESC' else this.dealer_name = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.user_last_name = 'DESC'
      this.job_title = 'DESC'
      this.department = 'DESC'
      this.dms_key = 'DESC'
      this.is_active = 'DESC'

    sortJobTitles: ->
      this.sortedBy = 'job_titles.job_title_name'
      if this.job_title == 'ASC' then this.job_title = 'DESC' else this.job_title = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.user_last_name = 'DESC'
      this.dealer_name = 'DESC'
      this.department = 'DESC'
      this.dms_key = 'DESC'
      this.is_active = 'DESC'

    sortDepartments: ->
      this.sortedBy = 'departments.department_name'
      if this.department == 'ASC' then this.department = 'DESC' else this.department = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.user_last_name = 'DESC'
      this.dealer_name = 'DESC'
      this.job_title = 'DESC'
      this.dms_key = 'DESC'
      this.is_active = 'DESC'

    sortDMSKeys: ->
      this.sortedBy = 'dms_key'
      if this.dms_key == 'ASC' then this.dms_key = 'DESC' else this.dms_key = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.user_last_name = 'DESC'
      this.dealer_name = 'DESC'
      this.job_title = 'DESC'
      this.department = 'DESC'
      this.is_active = 'DESC'

    sortIsActive: ->
      this.sortedBy = 'is_active'
      if this.is_active == 'ASC' then this.is_active = 'DESC' else this.is_active = 'ASC'
      $scope.requestControl.getEmployees()
      
      this.user_last_name = 'DESC'
      this.dealer_name = 'DESC'
      this.job_title = 'DESC'
      this.department = 'DESC'
      this.dms_key = 'DESC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'users.last_name'
        return this.user_last_name
      else if this.sortedBy == 'dealers.dealer_name'
        return this.dealer_name
      else if this.sortedBy == 'job_titles.job_title_name'
        return this.job_title
      else if this.sortedBy == 'departments.department_name'
        return this.department
      else if this.sortedBy == 'dms_key'
        return this.dms_key
      else if this.sortedBy == 'is_active'
        return this.is_active
  }

  $scope.paginationControl = {

    current_page: 1

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.getEmployees()
  }

################################################################
############## Requst Control ##################################

  $scope.requestControl = {

    users: []

    destroyEmployee: (employee_id) ->
      if employee_id && parseInt(employee_id, 10) > 0
        EmployeesService.destroyEmployee.query({ employee_id: employee_id }, (responseData) ->
          if responseData.errors == false
            console.log("hello world")
            $scope.paginationControl.current_page = 1
            $scope.requestControl.getEmployees()
        )

    editEmployee: (employee_id) ->
      if employee_id && parseInt(employee_id, 10) > 0
        window.location = "/employees/" + employee_id + "/edit"

    getEmployees: ->
      EmployeesService.getEmployees.query({ page: $scope.paginationControl.current_page, user_full_name: $scope.searchControl.filteredUserFullName(), dealer_name: $scope.searchControl.filteredDealerName(), sortBy: $scope.sortableControl.requestedSortBy(), sortableDirection: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
        $scope.requestControl.employees = responseData.data

        $scope.pagination = responseData.pagination
      )

  }

################################################################
################# Initialize ###################################

  init()

]
