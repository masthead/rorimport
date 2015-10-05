surveyApp.controller 'CallDetailsCtrl', ['$scope', '$http', 'CallDetailsService', '$location', '$sce', ($scope, $http, CallDetailsService, $location, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    setUpCallId()
    $scope.requestControl.getCallDetails()

################################################################
############## Other Initializers ##############################

  setUpCallId = ->
    if $('#call_id') && $('#call_id')[0].value && parseInt($('#call_id')[0].value, 10) > 0
      $scope.requestControl.callId = parseInt($('#call_id')[0].value, 10)

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    call: null

    callId: null

    customer: {

      attempt_count: null

      campaign_name: null

      full_name: null

      last_attempt_time: null

      phone_number: []

    }

    isLoading: false

    getCallDetails: ->
      if this.callId && this.callId > 0
        this.isLoading = true

        CallDetailsService.getCallDetails.query({ call_id: this.callId }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.call = responseData.call
            $scope.requestControl.customer = responseData.customer

            if $scope.requestControl.call && $scope.requestControl.call.call_id > 0
              if $scope.requestControl.call.recording && $scope.requestControl.call.recording.length > 0
                mp3Player = getHorrendous($scope.requestControl.call.call_id, $scope.requestControl.call.recording)

                $scope.requestControl.call.mp3Player = $sce.trustAsHtml(mp3Player)
              else
                $scope.requestControl.call.mp3Player = null

          $scope.requestControl.isLoading = false
        )

  }

################################################################
################# Initialize ###################################

  init()

]
