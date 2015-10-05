surveyApp.controller 'DealersCtrl', ['$scope', '$http', 'DealersService', '$location', '$pusher', ($scope, $http, DealersService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initializeNewSearch()
    $scope.requestControl.getDealers()

################################################################
############## Other Initializers ##############################

  initializeNewSearch = ->
    $scope.searchInput = {
      id: null

      dealer_focus_id: null

      dealer_name: null
    }

  $scope.searchControl = {
    filteredDealerName: ->
      angular.lowercase($scope.searchInput.dealer_name)

    filteredDealerId: ->
      $scope.searchInput.id

    filteredDealerFocusId: ->
      $scope.searchInput.dealer_focus_id
  }

  $scope.sortableControl = {

    sortedBy: 'dealer_name'

    id: 'DESC'

    dealer_focus_id: 'DESC'

    dealer_name: 'ASC'

    dealer_status: 'ASC'

    vendor: 'DESC'

    lat_lng: 'DESC'

    sortIds: ->
      this.sortedBy = 'id'
      if this.id == 'ASC' then this.id = 'DESC' else this.id = 'ASC'
      $scope.requestControl.getDealers()

      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerFocusIds: ->
      this.sortedBy = 'dealer_focus_id'
      if this.dealer_focus_id == 'ASC' then this.dealer_focus_id = 'DESC' else this.dealer_focus_id = 'ASC'
      $scope.requestControl.getDealers()

      this.id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerNames: ->
      this.sortedBy = 'dealer_name'
      if this.dealer_name == 'ASC' then this.dealer_name = 'DESC' else this.dealer_name = 'ASC'
      $scope.requestControl.getDealers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerStatus: ->
      this.sortedBy = 'dealer_status'
      if this.dealer_status == 'ASC' then this.dealer_status = 'DESC' else this.dealer_status = 'ASC'
      $scope.requestControl.getDealers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.vendor = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerVendors: ->
      this.sortedBy = 'vendor'
      if this.vendor == 'ASC' then this.vendor = 'DESC' else this.vendor = 'ASC'
      $scope.requestControl.getDealers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.lat_lng = 'DESC'

    sortDealerLatLngs: ->
      this.sortedBy = 'lat_lng'
      if this.lat_lng == 'ASC' then this.lat_lng = 'DESC' else this.lat_lng = 'ASC'
      $scope.requestControl.getDealers()
      
      this.id = 'DESC'
      this.dealer_focus_id = 'DESC'
      this.dealer_name = 'DESC'
      this.dealer_status = 'DESC'
      this.vendor = 'DESC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'dealer_name'
        return this.dealer_name
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
      $scope.requestControl.getDealers()
  }

################################################################
############## Requst Control ##################################

  $scope.requestControl = {

    activeDealers: null

    dealers: []

    totalDealers: null

    editDealer: (dealer_id) ->
      if dealer_id && parseInt(dealer_id, 10) > 0
        window.location = "/dealers/" + dealer_id + "/edit"

    getDealers: ->
      DealersService.getDealers.query({ page: $scope.paginationControl.current_page, dealer_id: $scope.searchControl.filteredDealerId(), dealer_name: $scope.searchControl.filteredDealerName(), dealer_focus_id: $scope.searchControl.filteredDealerFocusId(), sortBy: $scope.sortableControl.requestedSortBy(), sortableDirection: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
        $scope.requestControl.dealers = responseData.data
        $scope.requestControl.totalDealers = responseData.total_dealers
        $scope.requestControl.activeDealers = responseData.active_dealers
        
        $scope.pagination = responseData.pagination
      )

  }

################################################################
################# Initialize ###################################

  init()

]
