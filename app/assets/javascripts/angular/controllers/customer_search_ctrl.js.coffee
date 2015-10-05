surveyApp.controller 'CustomerSearchCtrl', ['$scope', '$http', 'CustomerSearchService', '$location', ($scope, $http, CustomerSearchService, $location) ->

###########################################################
############## Initial Page Load / Reset ##################

  init = ->
    $scope.searchedCustomers = []
    initializeNewSearch()

  initializeNewSearch = ->
    $scope.searchInput = {
      first_name: null,
      last_name: null,
      email: null,
      phone_number: null,
      address: null,
      vin: null
    }

  $scope.searchControl = {
    filteredFirstName: ->
      angular.lowercase($scope.searchInput.first_name)

    filteredLastName: ->
      angular.lowercase($scope.searchInput.last_name)

    filteredEmail: ->
      angular.lowercase($scope.searchInput.email)

    filteredPhoneNumber: ->
      $scope.searchInput.phone_number

    filteredAddress: ->
      angular.lowercase($scope.searchInput.address)
  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    searchCustomers: ->
      CustomerSearchService.searchCustomers.query({ first_name: $scope.searchControl.filteredFirstName(), last_name: $scope.searchControl.filteredLastName(), customer_email: $scope.searchControl.filteredEmail(), customer_phone: $scope.searchControl.filteredPhoneNumber(), customer_address: $scope.searchControl.filteredAddress(), vin: $scope.searchInput.vin }, (responseData) ->
        if responseData.errors == false
          $scope.searchedCustomers = responseData.search_results
      )

    viewCustomer: (customer) ->
      if customer.dealer_id && parseInt(customer.dealer_id, 10) > 0 && customer.customer_id && parseInt(customer.customer_id, 10) > 0
        window.location = '/dealers/' + customer.dealer_id + '/customers/' + customer.customer_id + '/edit'

  }

################################################################
################# Initialize ###################################

  init()

]
