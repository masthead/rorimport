surveyApp.controller 'CampaignDigestReportCtrl', ['$scope', '$http', 'CampaignDigestReportService', 'AgentReportService', '$location', '$pusher', '$sce', ($scope, $http, CampaignDigestReportService, AgentReportService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    console.log("In the init")

################################################################
############## Other Initializers ##############################

################################################################
########### Appointments Set Customers Control #################

  $scope.appointmentsSetCustomersControl = {

    campaignIdScoped: null

    campaignNameScoped: null

    current_page: 1

    appointmentsSetCustomers: []

    pagination: null

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(false, null)

    getData: (resetPage, campaignIdScoped) ->
      if resetPage == true then this.current_page = 1
      if campaignIdScoped then this.campaignIdScoped = campaignIdScoped

      if this.campaignIdScoped && parseInt(this.campaignIdScoped, 10) > 0
        $scope.loaderControl.updateLoading(true)

        CampaignDigestReportService.getAppointmentsSetCustomers.query({ page: this.current_page, campaign_id: this.campaignIdScoped }, (responseData) ->
          if responseData.errors == false
            $scope.appointmentsSetCustomersControl.appointmentsSetCustomers = responseData.appointments_set_customers
            $scope.appointmentsSetCustomersControl.pagination = responseData.pagination
            $scope.appointmentsSetCustomersControl.campaignNameScoped = responseData.campaign_name

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
################# Customers Contacted ##########################

  $scope.customersContactedControl = {

    campaignIdScoped: null

    campaignNameScoped: null

    current_page: 1

    pagination: null

    customersContacted: []

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(false, null)

    getData: (resetPage, campaignIdScoped) ->
      if resetPage == true then this.current_page = 1
      if campaignIdScoped then this.campaignIdScoped = campaignIdScoped

      if this.campaignIdScoped && parseInt(this.campaignIdScoped, 10) > 0
        $scope.loaderControl.updateLoading(true)

        CampaignDigestReportService.getCustomersContacted.query({ page: this.current_page, campaign_id: this.campaignIdScoped }, (responseData) ->
          if responseData.errors == false
            $scope.customersContactedControl.customersContacted = responseData.total_contacted_customers
            $scope.customersContactedControl.pagination = responseData.pagination
            $scope.customersContactedControl.campaignNameScoped = responseData.campaign_name

            if $scope.customersContactedControl.customersContacted && $scope.customersContactedControl.customersContacted.length > 0
              index = 0
              _($scope.customersContactedControl.customersContacted.length).times ->

                if $scope.customersContactedControl.customersContacted[index].campaign_customer_id && parseInt($scope.customersContactedControl.customersContacted[index].campaign_customer_id, 10) > 0 && $scope.customersContactedControl.customersContacted[index].recording && $scope.customersContactedControl.customersContacted[index].recording.length > 0
                  mp3Player = getHorrendous($scope.customersContactedControl.customersContacted[index].campaign_customer_id, $scope.customersContactedControl.customersContacted[index].recording)

                  $scope.customersContactedControl.customersContacted[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.customersContactedControl.customersContacted[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
############## Customers with Activity Control #################

  $scope.customersWithActivityControl = {

    campaignIdScoped: null

    campaignNameScoped: null

    current_page: 1

    customersWithActivity: []

    pagination: null

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(false, null)

    getData: (resetPage, campaignIdScoped) ->
      if resetPage == true then this.current_page = 1
      if campaignIdScoped then this.campaignIdScoped = campaignIdScoped

      if this.campaignIdScoped && parseInt(this.campaignIdScoped, 10) > 0
        $scope.loaderControl.updateLoading(true)

        CampaignDigestReportService.getCustomersWithActivity.query({ page: this.current_page, campaign_id: this.campaignIdScoped }, (responseData) ->
          if responseData.errors == false
            $scope.customersWithActivityControl.customersWithActivity = responseData.total_customers
            $scope.customersWithActivityControl.pagination = responseData.pagination
            $scope.customersWithActivityControl.campaignNameScoped = responseData.campaign_name

            if $scope.customersWithActivityControl.customersWithActivity && $scope.customersWithActivityControl.customersWithActivity.length > 0
              index = 0
              _($scope.customersWithActivityControl.customersWithActivity.length).times ->

                if $scope.customersWithActivityControl.customersWithActivity[index].campaign_customer_id && parseInt($scope.customersWithActivityControl.customersWithActivity[index].campaign_customer_id, 10) > 0 && $scope.customersWithActivityControl.customersWithActivity[index].recording && $scope.customersWithActivityControl.customersWithActivity[index].recording.length > 0
                  mp3Player = getHorrendous($scope.customersWithActivityControl.customersWithActivity[index].campaign_customer_id, $scope.customersWithActivityControl.customersWithActivity[index].recording)

                  $scope.customersWithActivityControl.customersWithActivity[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.customersWithActivityControl.customersWithActivity[index].mp3Player = null

                index += 1

          $scope.loaderControl.updateLoading(false)
        )

  }

################################################################
################# Hot Alert Customers Control ##################

  $scope.hotAlertCustomersControl = {

    campaignIdScoped: null

    campaignNameScoped: null

    current_page: 1

    hotAlertCustomers: []

    pagination: null

    changePage: (page_number) ->
      this.current_page = page_number
      $scope.requestControl.resetCallToSendParams()

      this.getData(false, null)

    getData: (resetPage, campaignIdScoped) ->
      if resetPage == true then this.current_page = 1
      if campaignIdScoped then this.campaignIdScoped = campaignIdScoped

      if this.campaignIdScoped && parseInt(this.campaignIdScoped, 10) > 0
        $scope.loaderControl.updateLoading(true)

        CampaignDigestReportService.getHotAlertCustomers.query({ page: this.current_page, campaign_id: this.campaignIdScoped }, (responseData) ->
          if responseData.errors == false
            $scope.hotAlertCustomersControl.hotAlertCustomers = responseData.hot_alert_customers
            $scope.hotAlertCustomersControl.pagination = responseData.pagination
            $scope.hotAlertCustomersControl.campaignNameScoped = responseData.campaign_name

            if $scope.hotAlertCustomersControl.hotAlertCustomers && $scope.hotAlertCustomersControl.hotAlertCustomers.length > 0
              index = 0
              _($scope.hotAlertCustomersControl.hotAlertCustomers.length).times ->

                if $scope.hotAlertCustomersControl.hotAlertCustomers[index].campaign_customer_id && parseInt($scope.hotAlertCustomersControl.hotAlertCustomers[index].campaign_customer_id, 10) > 0 && $scope.hotAlertCustomersControl.hotAlertCustomers[index].recording && $scope.hotAlertCustomersControl.hotAlertCustomers[index].recording.length > 0
                  mp3Player = getHorrendous($scope.hotAlertCustomersControl.hotAlertCustomers[index].campaign_customer_id, $scope.hotAlertCustomersControl.hotAlertCustomers[index].recording)

                  $scope.hotAlertCustomersControl.hotAlertCustomers[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.hotAlertCustomersControl.hotAlertCustomers[index].mp3Player = null

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
################# Initialize ###################################

  init()

]
