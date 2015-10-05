surveyApp.controller 'CampaignReportCtrl', ['$scope', '$http', 'CampaignReportService', 'AgentReportService', '$location', '$pusher', '$sce', ($scope, $http, CampaignReportService, AgentReportService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    console.log("In the init")
    setGeneralParams()

################################################################
############## Other Initializers ##############################

  $scope.checkDataToggle = (className) ->
    if $(className) && $(className).length > 0 && $(className)[0].getAttribute("data-toggle") == "tooltip"
      $(className)[0].setAttribute("data-toggle", "modal");

  setGeneralParams = ->
    $scope.generalParams = {
      start_date: if $('input[name=start_date]') && $('input[name=start_date]').length > 0 then $('input[name=start_date]')[0].value else null

      end_date: if $('input[name=end_date]') && $('input[name=end_date]').length > 0 then $('input[name=end_date]')[0].value else null 
    }

    if $('#campaign_id option[selected]') && $('#campaign_id option[selected]').length > 0 && $('#campaign_id option[selected]')[0].value.split("_") && $('#campaign_id option[selected]')[0].value.split("_").length == 2
      campaign_id_and_type = $('#campaign_id option[selected]')[0].value
      $scope.generalParams["campaign_id"] = campaign_id_and_type.split("_")[0]
      $scope.generalParams["model"] = campaign_id_and_type.split("_")[1]

################################################################
################# Appointments Set Control #####################

  $scope.appointmentsSetCustomersControl = {

    current_page: 1

    pagination: null

    appointmentsSetCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getAppointmentsSetCustomersData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.appointmentsSetCustomersControl.appointmentsSetCustomers = responseData.appointments_set_customers
            $scope.appointmentsSetCustomersControl.pagination = responseData.pagination

            if $scope.appointmentsSetCustomersControl.appointmentsSetCustomers && $scope.appointmentsSetCustomersControl.appointmentsSetCustomers.length > 0
              index = 0
              _($scope.appointmentsSetCustomersControl.appointmentsSetCustomers.length).times ->

                if $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].campaign_customer_id && parseInt($scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].campaign_customer_id, 10) > 0 && $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].recording && $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].campaign_customer_id, $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].recording)

                  $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.appointmentsSetCustomersControl.appointmentsSetCustomers[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Dispositions #################################

  $scope.dispositionsControl = {

    current_page: 1

    dispositionIdScoped: null

    pagination: null

    surveyAttempts: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(null, false, null)

    downloadRecording: (surveyAttempt) ->
      if surveyAttempt && surveyAttempt.recording
        window.open(surveyAttempt.recording, "_blank")

      return null

    getData: (className, resetPage, dispositionIdScoped) ->
      $scope.checkDataToggle(className)

      if resetPage == true then this.current_page = 1
      if dispositionIdScoped then this.dispositionIdScoped = dispositionIdScoped

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getDispositionData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page, disposition_id: this.dispositionIdScoped }, (responseData) ->
          if responseData.errors == false
            $scope.dispositionsControl.surveyAttempts = responseData.survey_attempts
            $scope.dispositionsControl.pagination = responseData.pagination

            if $scope.dispositionsControl.surveyAttempts && $scope.dispositionsControl.surveyAttempts.length > 0
              index = 0
              _($scope.dispositionsControl.surveyAttempts.length).times ->

                if $scope.dispositionsControl.surveyAttempts[index].campaign_customer_id && parseInt($scope.dispositionsControl.surveyAttempts[index].campaign_customer_id, 10) > 0 && $scope.dispositionsControl.surveyAttempts[index].recording && $scope.dispositionsControl.surveyAttempts[index].recording.length > 0
                  mp3Player = getHorrendous($scope.dispositionsControl.surveyAttempts[index].campaign_customer_id, $scope.dispositionsControl.surveyAttempts[index].recording)

                  $scope.dispositionsControl.surveyAttempts[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.dispositionsControl.surveyAttempts[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)

        )

  }

################################################################
################# Loader Control ###############################

  $scope.loaderControl = {

    isLoading: false

    updateLoading: (boolean) ->
      this.isLoading = boolean

  }

################################################################
################# No Contact Customers #########################

  $scope.noContactCustomersControl = {

    current_page: 1

    pagination: null

    noContactCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getNoContactCustomersData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.noContactCustomersControl.noContactCustomers = responseData.no_contact_customers
            $scope.noContactCustomersControl.pagination = responseData.pagination

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Question With Answers ########################

  $scope.questionsWithAnswersControl = {

    answerTextScoped: null

    current_page: 1

    pagination: null

    questionIdScoped: null

    questionAnswersCustomers: []

    scopedQuestionReportQuestionText: null

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(null, false, null)

    getData: (className, resetPage, questionIdScoped, answerTextScoped) ->
      $scope.checkDataToggle(className)

      if resetPage == true then this.current_page = 1
      if questionIdScoped then this.questionIdScoped = questionIdScoped
      if answerTextScoped then this.answerTextScoped = answerTextScoped

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model && this.questionIdScoped && parseInt(this.questionIdScoped, 10) > 0 && this.answerTextScoped && this.answerTextScoped.length > 0
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getQuestionAnswerSurveyData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page, survey_template_question_id: this.questionIdScoped, answer_text: this.answerTextScoped }, (responseData) ->
          if responseData.errors == false
            $scope.questionsWithAnswersControl.questionAnswersCustomers = responseData.answer_customers
            $scope.questionsWithAnswersControl.pagination = responseData.pagination
            $scope.questionsWithAnswersControl.scopedQuestionReportQuestionText = responseData.question_report_question_text

            if $scope.questionsWithAnswersControl.questionAnswersCustomers && $scope.questionsWithAnswersControl.questionAnswersCustomers.length > 0
              index = 0
              _($scope.questionsWithAnswersControl.questionAnswersCustomers.length).times ->

                if $scope.questionsWithAnswersControl.questionAnswersCustomers[index].campaign_customer_id && parseInt($scope.questionsWithAnswersControl.questionAnswersCustomers[index].campaign_customer_id, 10) > 0 && $scope.questionsWithAnswersControl.questionAnswersCustomers[index].recording && $scope.questionsWithAnswersControl.questionAnswersCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.questionsWithAnswersControl.questionAnswersCustomers[index].campaign_customer_id, $scope.questionsWithAnswersControl.questionAnswersCustomers[index].recording)

                  $scope.questionsWithAnswersControl.questionAnswersCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.questionsWithAnswersControl.questionAnswersCustomers[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

    resetParams: ->
      this.answerTextScoped = null
      this.current_page = 1
      this.pagination = null
      this.questionIdScoped = null
      this.questionAnswersCustomers = []
      this.scopedQuestionReportQuestionText = null
  }

################################################################
################# Remaining Customers ##########################

  $scope.remainingCustomersControl = {

    current_page: 1

    pagination: null

    remainingCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getRemainingCustomersData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.remainingCustomersControl.remainingCustomers = responseData.remaining_customers
            $scope.remainingCustomersControl.pagination = responseData.pagination
        
          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    callToSendId: null

    emailToSendRecording: null

    isEmailing: false

    moreOptions: false

    checkIsEmailing: ->
      if this.moreOptions && this.moreOptions == true then return 'body-scrollable' else return null

    checkSendRecordingButton: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then null else 'disabled'

    downloadRecording: (campaignCustomer) ->
      if campaignCustomer && campaignCustomer.recording
        window.open(campaignCustomer.recording, "_blank")

      return null

    emailCallRecording: ->
      if this.emailToSendRecording && this.emailToSendRecording.length && this.verifyEmail(this.emailToSendRecording) && this.callToSendId && parseInt(this.callToSendId, 10) > 0
        this.isEmailing = true

        AgentReportService.emailCallRecording.query({ email: this.emailToSendRecording, call_id: this.callToSendId }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully sent call recording.")

            $scope.requestControl.resetCallToSendParams()

          $scope.requestControl.isEmailing = false
        )

    emailCheck: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then 'has-success' else 'has-error'

    resetCallToSendParams: ->
      this.callToSendId = null
      this.emailToSendRecording = null
      this.moreOptions = false

    setMoreOptions: (call_id) ->
      if call_id && call_id > 0
        this.moreOptions = true

        this.callToSendId = call_id

    verifyEmail: (email) ->
      expression = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      
      return expression.test(email)

    viewSurvey: (dealerId, surveyId) ->
      if dealerId && parseInt(dealerId, 10) > 0 && surveyId && parseInt(surveyId, 10) > 0
        window.open("/dealers/" + dealerId + '/surveys/' + surveyId, "_blank")

      return null

  }

################################################################
################# Survey Alerts Control ########################

  $scope.surveyAlertsCustomersControl = {

    current_page: 1

    pagination: null

    surveyAlertsCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getSurveyAlertsData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.surveyAlertsCustomersControl.surveyAlertsCustomers = responseData.hot_alert_customers
            $scope.surveyAlertsCustomersControl.pagination = responseData.pagination

            if $scope.surveyAlertsCustomersControl.surveyAlertsCustomers && $scope.surveyAlertsCustomersControl.surveyAlertsCustomers.length > 0
              index = 0
              _($scope.surveyAlertsCustomersControl.surveyAlertsCustomers.length).times ->

                if $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].campaign_customer_id && parseInt($scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].campaign_customer_id, 10) > 0 && $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].recording && $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].campaign_customer_id, $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].recording)

                  $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.surveyAlertsCustomersControl.surveyAlertsCustomers[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Total Contacted Customers ####################

  $scope.totalContactedCustomersControl = {

    current_page: 1

    pagination: null

    totalContactedCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getTotalContactedCustomersData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.totalContactedCustomersControl.totalContactedCustomers = responseData.total_contacted_customers
            $scope.totalContactedCustomersControl.pagination = responseData.pagination

            if $scope.totalContactedCustomersControl.totalContactedCustomers && $scope.totalContactedCustomersControl.totalContactedCustomers.length > 0
              index = 0
              _($scope.totalContactedCustomersControl.totalContactedCustomers.length).times ->

                if $scope.totalContactedCustomersControl.totalContactedCustomers[index].campaign_customer_id && parseInt($scope.totalContactedCustomersControl.totalContactedCustomers[index].campaign_customer_id, 10) > 0 && $scope.totalContactedCustomersControl.totalContactedCustomers[index].recording && $scope.totalContactedCustomersControl.totalContactedCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.totalContactedCustomersControl.totalContactedCustomers[index].campaign_customer_id, $scope.totalContactedCustomersControl.totalContactedCustomers[index].recording)

                  $scope.totalContactedCustomersControl.totalContactedCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.totalContactedCustomersControl.totalContactedCustomers[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Total Customers ##############################

  $scope.totalCustomersControl = {

    current_page: 1

    pagination: null

    totalCustomers: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()
      
      this.getData()

    getData: (className) ->
      $scope.checkDataToggle(className)

      if $scope.generalParams.start_date && $scope.generalParams.end_date && $scope.generalParams.campaign_id && parseInt($scope.generalParams.campaign_id, 10) > 0 && $scope.generalParams.model
        $scope.loaderControl.updateLoading(true)

        CampaignReportService.getTotalCustomersData.query({ start_date: $scope.generalParams.start_date, end_date: $scope.generalParams.end_date, id: $scope.generalParams.campaign_id, model: $scope.generalParams.model, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.totalCustomersControl.totalCustomers = responseData.total_customers
            $scope.totalCustomersControl.pagination = responseData.pagination

            if $scope.totalCustomersControl.totalCustomers && $scope.totalCustomersControl.totalCustomers.length > 0
              index = 0
              _($scope.totalCustomersControl.totalCustomers.length).times ->

                if $scope.totalCustomersControl.totalCustomers[index].campaign_customer_id && parseInt($scope.totalCustomersControl.totalCustomers[index].campaign_customer_id, 10) > 0 && $scope.totalCustomersControl.totalCustomers[index].recording && $scope.totalCustomersControl.totalCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.totalCustomersControl.totalCustomers[index].campaign_customer_id, $scope.totalCustomersControl.totalCustomers[index].recording)

                  $scope.totalCustomersControl.totalCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.totalCustomersControl.totalCustomers[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )
  }

################################################################
################# Initialize ###################################

  init()

]
