surveyApp.controller 'CSIReportCtrl', ['$scope', '$http', 'CSIReportService', '$location', '$pusher', '$sce', ($scope, $http, CSIReportService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    console.log("In the CSIReportCtrl init")

################################################################
############## Other Initializers ##############################

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    current_page: 1

    isFetching: false

    pagination: null

    scopedCampaignCustomerId: null

    surveyAttempts: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getSurveyAttempts()

    downloadRecording: (call) ->
      if call && call.recording
        window.open(call.recording, "_blank")

      return null

    getSurveyAttempts: (campaignCustomerId) ->
      if campaignCustomerId then this.scopedCampaignCustomerId = campaignCustomerId
      if this.surveyAttempts && this.surveyAttempts.length > 0 then this.surveyAttempts = []

      if this.scopedCampaignCustomerId && parseInt(this.scopedCampaignCustomerId, 10) > 0
        this.isFetching = true

        CSIReportService.getSurveyAttempts.query({ campaign_customer_id: this.scopedCampaignCustomerId }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.surveyAttempts = responseData.survey_attempts

            if $scope.requestControl.surveyAttempts && $scope.requestControl.surveyAttempts.length > 0
              index = 0
              _($scope.requestControl.surveyAttempts.length).times ->

                if $scope.requestControl.surveyAttempts[index].campaign_customer_id && parseInt($scope.requestControl.surveyAttempts[index].campaign_customer_id, 10) > 0 && $scope.requestControl.surveyAttempts[index].recording && $scope.requestControl.surveyAttempts[index].recording.length > 0
                  mp3Player = getHorrendous($scope.requestControl.surveyAttempts[index].campaign_customer_id, $scope.requestControl.surveyAttempts[index].recording)

                  $scope.requestControl.surveyAttempts[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.requestControl.surveyAttempts[index].mp3Player = null

                index += 1

          $scope.requestControl.isFetching = false
        )
  }

################################################################
################# Initialize ###################################

  init()

]
