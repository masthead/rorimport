surveyApp.controller 'UsersCtrl', ['$scope', '$http', 'UsersService', '$location', '$pusher', ($scope, $http, UsersService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initializeNewSearch()
    $scope.requestControl.getUsers()

################################################################
############## Other Initializers ##############################

  initializeNewSearch = ->
    $scope.searchInput = {
      id: null

      full_name: null
    }

  $scope.searchControl = {
    filteredFullName: ->
      angular.lowercase($scope.searchInput.full_name)

    filteredUserId: ->
      $scope.searchInput.id

    filteredEmail: ->
      angular.lowercase($scope.searchInput.email)

  }

  $scope.sortableControl = {

    sortedBy: 'full_name'

    id: 'DESC'

    full_name: 'ASC'

    email: 'DESC'

    sortIds: ->
      this.sortedBy = 'id'
      if this.id == 'ASC' then this.id = 'DESC' else this.id = 'ASC'
      $scope.requestControl.getUsers()

      this.full_name = 'DESC'
      this.email = 'DESC'

    sortFullNames: ->
      this.sortedBy = 'full_name'
      if this.full_name == 'ASC' then this.full_name = 'DESC' else this.full_name = 'ASC'
      $scope.requestControl.getUsers()
      
      this.id = 'DESC'
      this.email = 'DESC'

    sortEmails: ->
      this.sortedBy = 'email'
      if this.email == 'ASC' then this.email = 'DESC' else this.email = 'ASC'
      $scope.requestControl.getUsers()
      
      this.id = 'DESC'
      this.full_name = 'DESC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'full_name'
        return this.full_name
      else if this.sortedBy == 'id'
        return this.id
      else if this.sortedBy == 'email'
        return this.email
  }

  $scope.paginationControl = {

    current_page: 1

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.getUsers()
  }

################################################################
############## Requst Control ##################################

  $scope.requestControl = {

    users: []

    editUser: (user_id) ->
      if user_id && parseInt(user_id, 10) > 0
        window.location = "/users/" + user_id + "/edit"

    getUsers: ->
      UsersService.getUsers.query({ page: $scope.paginationControl.current_page, user_id: $scope.searchControl.filteredUserId(), full_name: $scope.searchControl.filteredFullName(), email: $scope.searchControl.filteredEmail(), sortBy: $scope.sortableControl.requestedSortBy(), sortableDirection: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
        $scope.requestControl.users = responseData.data

        $scope.pagination = responseData.pagination
      )

  }

################################################################
################# Initialize ###################################

  init()

]
