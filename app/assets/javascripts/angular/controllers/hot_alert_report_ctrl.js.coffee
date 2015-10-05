surveyApp.controller 'HotAlertReportCtrl', ['$scope', '$http', 'HotAlertReportService', 'AgentReportService', '$location', '$pusher', '$sce', ($scope, $http, HotAlertReportService, AgentReportService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    console.log("In the init")

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

    callToSendId: null

    emailToSendRecording: null

    checkSendRecordingButton: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then null else 'disabled'

    emailCallRecording: ->
      if this.emailToSendRecording && this.emailToSendRecording.length && this.verifyEmail(this.emailToSendRecording) && this.callToSendId && parseInt(this.callToSendId, 10) > 0
        AgentReportService.emailCallRecording.query({ email: this.emailToSendRecording, call_id: this.callToSendId }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully sent call recording.")
        )

    emailCheck: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then 'has-success' else 'has-error'

    resendAlert: (surveyId) ->
      if surveyId && parseInt(surveyId, 10) > 0
        HotAlertReportService.resendAlert.query({ survey_id: surveyId }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully resent survey alert!")
        )

    resetCallToSendParams: ->
      this.callToSendId = null
      this.emailToSendRecording = null

    setSendCallRecordingId: (callId) ->
      if callId && parseInt(callId, 10) > 0
        this.callToSendId = callId

    verifyEmail: (email) ->
      expression = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      
      return expression.test(email)

  }

################################################################
################# Initialize ###################################

  init()


]
