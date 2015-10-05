surveyApp.controller 'CustomersCtrl', ['$scope', '$http', 'CustomersService', '$location', '$pusher', ($scope, $http, CustomersService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initializeNewSearch()
    $scope.requestControl.getCustomers()

################################################################
############## Other Initializers ##############################

  initializeNewSearch = ->
    $scope.searchInput = {
      id: null

      dealer_focus_id: null

      customer_name: null
    }

  $scope.searchControl = {
    filteredCustomerName: ->
      angular.lowercase($scope.searchInput.customer_name)

    filteredCustomerId: ->
      $scope.searchInput.id

    filteredDealerFocusId: ->
      $scope.searchInput.dealer_focus_id
  }

  $scope.sortableControl = {

    sortedBy: 'dealer_name'

    id: 'DESC'

    dealer_focus_id: 'DESC'

    customer_name: 'ASC'

    dealer_status: 'ASC'

    vendor: 'DESC'

    lat_lng: 'DESC'

    sortIds: ->
      this.sortedBy = 'id'
      if this.id == 'ASC' then this.id = 'DESC' else this.id = 'ASC'
      $scope.requestControl.getCustomers()

      this.dealer_focus_id = 'DESC'
      this.customer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerFocusIds: ->
      this.sortedBy = 'dealer_focus_id'
      if this.dealer_focus_id == 'ASC' then this.dealer_focus_id = 'DESC' else this.dealer_focus_id = 'ASC'
      $scope.requestControl.getCustomers()

      this.id = 'DESC'
      this.customer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerNames: ->
      this.sortedBy = 'dealer_name'
      if this.dealer_name == 'ASC' then this.dealer_name = 'DESC' else this.dealer_name = 'ASC'
      $scope.requestControl.getCustomers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerStatus: ->
      this.sortedBy = 'dealer_status'
      if this.dealer_status == 'ASC' then this.dealer_status = 'DESC' else this.dealer_status = 'ASC'
      $scope.requestControl.getCustomers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerVendors: ->
      this.sortedBy = 'vendor'
      if this.vendor == 'ASC' then this.vendor = 'DESC' else this.vendor = 'ASC'
      $scope.requestControl.getCustomers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerLatLngs: ->
      this.sortedBy = 'lat_lng'
      if this.lat_lng == 'ASC' then this.lat_lng = 'DESC' else this.lat_lng = 'ASC'
      $scope.requestControl.getCustomers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'dealer_name'
        return this.customer_name
      else if this.sortedBy == 'id'
        return this.id
      else if this.sortedBy == 'dealer_focus_id'
        return this.dealer_focus_id
      else if this.sortedBy == 'dealer_status'
        return this.dealer_status
      else if this.sortedBy == 'vendor'
        return this.vendor
      else if this.sortedBy == 'lat_lng'
        return this.lat_lng
  }

  $scope.paginationControl = {

    current_page: 1

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.getCustomers()
  }

################################################################
############## Requst Control ##################################

  $scope.requestControl = {

    customers: []

    totalCustomers: null

    editCustomer: (customer_id) ->
      if customer_id && parseInt(customer_id, 10) > 0
        window.location = "/dealers/" + customer_id + "/edit"

    getDealers: ->
      DealersService.getCustomers.query({ page: $scope.paginationControl.current_page, dealer_id: $scope.searchControl.filteredCustomerId(), dealer_name: $scope.searchControl.filteredCustomerName(), dealer_focus_id: $scope.searchControl.filteredDealerFocusId(), sortBy: $scope.sortableControl.requestedSortBy(), sortableDirection: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
        $scope.requestControl.customers = responseData.data
        $scope.requestControl.totalCustomers = responseData.total_customers
        
        $scope.pagination = responseData.pagination
      )

  }

################################################################
################# Initialize ###################################

  init()

]
