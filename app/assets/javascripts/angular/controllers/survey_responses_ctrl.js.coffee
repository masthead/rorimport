surveyApp.controller 'SurveyResponsesCtrl', ['$scope', '$http', 'SurveyResponsesService', 'AgentReportService', '$location', '$sce', ($scope, $http, SurveyResponsesService, AgentReportService, $location, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    setUpSurveyId()
    setUpSurveyResponseId()
    setUpUserId()
    $scope.requestControl.getSurveyCallDetails()
    $scope.requestControl.getSurveyResponses()

################################################################
############## Other Initializers ##############################

  setUpSurveyId = ->
    if $('#survey_id') && $('#survey_id')[0].value && parseInt($('#survey_id')[0].value, 10) > 0
      $scope.requestControl.surveyId = parseInt($('#survey_id')[0].value, 10)

  setUpSurveyResponseId = ->
    if $('#survey_response_id') && $('#survey_response_id')[0].value && parseInt($('#survey_response_id')[0].value, 10) > 0
      $scope.requestControl.surveyResponseId = parseInt($('#survey_response_id')[0].value, 10)

  setUpUserId = ->
    if $('#user_id') && $('#user_id')[0].value && parseInt($('#user_id')[0].value, 10) > 0
      $scope.requestControl.userId = parseInt($('#user_id')[0].value, 10)

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    call: null

    callToSendId: null

    emailToSendRecording: null

    isCreating: false

    responseText: null

    surveyId: null

    surveyResponseId: null

    surveyResponses: []

    userId: null

    checkSendRecordingButton: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then null else 'disabled'

    checkSubmitResponse: ->
      if this.responseText && this.responseText.length > 0 then null else 'disabled'

    createSurveyResponse: ->
      if this.surveyId && this.surveyId > 0 && this.userId && this.userId > 0 && this.responseText && this.responseText.length > 0
        this.isCreating = true

        SurveyResponsesService.createSurveyResponse.query({ survey_id: this.surveyId, user_id: this.userId, response_text: this.responseText }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.responseText = null
            $scope.requestControl.surveyResponses = responseData.survey_responses
            $scope.requestControl.isCreating = false

            gritterAdd("Successfully created survey response.")
        )

    downloadRecording: (call) ->
      if call && call.recording
        window.open(call.recording, "_blank")

      return null

    emailCallRecording: ->
      if this.emailToSendRecording && this.emailToSendRecording.length && this.verifyEmail(this.emailToSendRecording) && this.call && this.call.call_id && this.call.call_id > 0
        AgentReportService.emailCallRecording.query({ email: this.emailToSendRecording, call_id: this.call.call_id }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully sent call recording.")
        )

    emailCheck: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then 'has-success' else 'has-error'

    getSurveyCallDetails: ->
      if this.surveyId && this.surveyId > 0
        SurveyResponsesService.getSurveyCallDetails.query({ survey_id: this.surveyId }, (responseData) -> 
          if responseData.errors == false
            $scope.requestControl.call = responseData.call

            if $scope.requestControl.call && $scope.requestControl.call.call_id > 0
              if $scope.requestControl.call.recording && $scope.requestControl.call.recording.length > 0
                mp3Player = getHorrendous($scope.requestControl.call.call_id, $scope.requestControl.call.recording)

                $scope.requestControl.call.mp3Player = $sce.trustAsHtml(mp3Player)
              else
                $scope.requestControl.call.mp3Player = null
        )

    getSurveyResponses: ->
      if this.surveyId && this.surveyId > 0
        SurveyResponsesService.getSurveyResponses.query({ survey_id: this.surveyId }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.surveyResponses = responseData.survey_responses
        )

    resendAlert: (surveyId) ->
      if surveyId && parseInt(surveyId, 10) > 0
        HotAlertReportService.resendAlert.query({ survey_id: surveyId }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully resent survey alert!")
        )

    resetCallToSendParams: ->
      this.emailToSendRecording = null

    verifyEmail: (email) ->
      expression = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      
      return expression.test(email)

  }

################################################################
################# Initialize ###################################

  init()


]
