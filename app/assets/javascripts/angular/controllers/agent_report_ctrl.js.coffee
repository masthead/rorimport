surveyApp.controller 'AgentReportCtrl', ['$scope', '$http', 'AgentReportService', '$location', '$pusher', '$sce', ($scope, $http, AgentReportService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    setAgentId()

    initializeNewSearch()

    $scope.requestControl.getCalls()

    $scope.typeaheadControl.getTypeaheadValues()

################################################################
############## Other Initializers ##############################

  setAgentId = ->
    if $('#agent_id') && $('#agent_id').length > 0 && parseInt($('#agent_id')[0].value, 10) > 0
      $scope.requestControl.agentId = $('#agent_id')[0].value

################################################################
################# Stats Control ################################

  $scope.statsControl = {

    averageCallLength: null

    callsOver4Minutes: null

    inboundCalls: null

    outboundCalls: null

    surveysCompleted: null

    totalCalls: null

  }

###########################################################
################# Datepickers #############################

  $scope.endDatepicker = {

    dateOptions: {
      formatYear: 'yy',
      startingDay: 1,
      showWeeks: false
    };

    format: 'dd-MMMM-yyyy';

    minDate: new Date()

    opened: false

    clear: ->
      $scope.searchInput.end_date = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.searchInput.end_date == null
        this.today()

      $scope.endDatepicker.opened = true;

    today: ->
      $scope.searchInput.end_date = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

  $scope.startDatepicker = {

    dateOptions: {
      formatYear: 'yy',
      startingDay: 1,
      showWeeks: false
    };

    format: 'dd-MMMM-yyyy';

    minDate: new Date()

    opened: false

    clear: ->
      $scope.searchInput.start_date = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.searchInput.start_date == null
        this.today()

      $scope.startDatepicker.opened = true;

    today: ->
      $scope.searchInput.start_date = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

################################################################
################# Search Control ###############################

  initializeNewSearch = ->
    $scope.searchInput = {

      campaign: null

      dealer: null

      friendly_direction: null

      end_date: null

      friendly_from_number: null

      start_date: null

      friendly_to_number: null

      friendly_duration: null

      paramsCheck: ->
        if (this.campaign && this.campaign.id && parseInt(this.campaign.id, 10) > 0) || (this.dealer && this.dealer.id && parseInt(this.dealer.id, 10) > 0) || (this.friendly_from_number && this.friendly_from_number.length > 0) || (this.friendly_to_number && this.friendly_to_number.length > 0) || this.start_date || this.end_date || this.friendly_direction
          return true
        else
          return false

      resetParams: ->
        this.campaign = null
        this.dealer = null
        this.friendly_direction = null
        this.end_date = null
        this.friendly_from_number = null
        this.start_date = null
        this.friendly_to_number = null
        this.friendly_duration = null
    }

################################################################
################# Sortable Control #############################

  $scope.sortableControl = {

    sortedBy: 'created_at'

    created_at: 'DESC'

    dealer_name: 'DESC'

    friendly_duration: 'DESC'

    friendly_from_number: 'DESC'

    friendly_to_number: 'DESC'

    campaign_name: 'DESC'

    friendly_direction: 'DESC'

    sortCreatedAts: ->
      this.sortedBy = 'created_at'
      if this.created_at == 'DESC' then this.created_at = 'ASC' else this.created_at = 'DESC'
      $scope.requestControl.getCalls()

      this.dealer_name = 'DESC'
      this.friendly_duration = 'DESC'
      this.friendly_from_number = 'DESC'
      this.friendly_to_number = 'DESC'
      this.campaign_name = 'DESC'
      this.friendly_direction = 'DESC'

    sortDealerNames: ->
      this.sortedBy = 'dealer_name'
      if this.dealer_name == 'ASC' then this.dealer_name = 'DESC' else this.dealer_name = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.friendly_duration = 'DESC'
      this.friendly_from_number = 'DESC'
      this.friendly_to_number = 'DESC'
      this.campaign_name = 'DESC'
      this.friendly_direction = 'DESC'

    sortFriendlyDurations: ->
      this.sortedBy = 'friendly_duration'
      if this.friendly_duration == 'ASC' then this.friendly_duration = 'DESC' else this.friendly_duration = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.dealer_name = 'DESC'
      this.friendly_from_number = 'DESC'
      this.friendly_to_number = 'DESC'
      this.campaign_name = 'DESC'
      this.friendly_direction = 'DESC'

    sortFriendlyFromNumbers: ->
      this.sortedBy = 'friendly_from_number'
      if this.friendly_from_number == 'ASC' then this.friendly_from_number = 'DESC' else this.friendly_from_number = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.dealer_name = 'DESC'
      this.friendly_duration = 'DESC'
      this.friendly_to_number = 'DESC'
      this.campaign_name = 'DESC'
      this.friendly_direction = 'DESC'

    sortFriendlyToNumbers: ->
      this.sortedBy = 'friendly_to_number'
      if this.friendly_to_number == 'ASC' then this.friendly_to_number = 'DESC' else this.friendly_to_number = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.dealer_name = 'DESC'
      this.friendly_duration = 'DESC'
      this.friendly_from_number = 'DESC'
      this.campaign_name = 'DESC'
      this.friendly_direction = 'DESC'

    sortCampaignNames: ->
      this.sortedBy = 'campaign_name'
      if this.campaign_name == 'ASC' then this.campaign_name = 'DESC' else this.campaign_name = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.dealer_name = 'DESC'
      this.friendly_duration = 'DESC'
      this.friendly_from_number = 'DESC'
      this.friendly_to_number = 'DESC'
      this.friendly_direction = 'DESC'

    sortFriendlyDirections: ->
      this.sortedBy = 'friendly_direction'
      if this.friendly_direction == 'ASC' then this.friendly_direction = 'DESC' else this.friendly_direction = 'ASC'
      $scope.requestControl.getCalls()

      this.created_at = 'ASC'
      this.dealer_name = 'DESC'
      this.friendly_duration = 'DESC'
      this.friendly_from_number = 'DESC'
      this.friendly_to_number = 'DESC'
      this.campaign_name = 'DESC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'created_at'
        return this.created_at
      else if this.sortedBy == 'dealer_name'
        return this.dealer_name
      else if this.sortedBy == 'friendly_duration'
        return this.friendly_duration
      else if this.sortedBy == 'friendly_from_number'
        return this.friendly_from_number
      else if this.sortedBy == 'friendly_to_number'
        return this.friendly_to_number
      else if this.sortedBy == 'campaign_name'
        return this.campaign_name
      else if this.sortedBy == 'friendly_direction'
        return this.friendly_direction

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    agentId: null

    calls: []

    callToSendId: null

    dateRange: null

    emailToSendRecording: null

    current_page: 1

    is4Minute: false

    isInbound: false

    isLoading: false

    isOutbound: false

    isSearching: false

    pagination: null

    changePage: (page_number) ->
      this.current_page = page_number
      this.getCalls()

    checkSendRecordingButton: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then null else 'disabled'

    downloadRecording: (call) ->
      if call && call.recording
        window.open(call.recording, "_blank")

      return null

    emailCallRecording: ->
      if this.emailToSendRecording && this.emailToSendRecording.length && this.verifyEmail(this.emailToSendRecording) && this.callToSendId && parseInt(this.callToSendId, 10) > 0
        AgentReportService.emailCallRecording.query({ email: this.emailToSendRecording, call_id: this.callToSendId }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully sent call recording.")
        )

    emailCheck: ->
      if this.emailToSendRecording && this.emailToSendRecording.length > 0 && this.verifyEmail(this.emailToSendRecording) then 'has-success' else 'has-error'

    getCalls: ->
      if this.agentId && parseInt(this.agentId, 10) > 0

        if $scope.searchInput.dealer && $scope.searchInput.dealer.dealer_name && $scope.searchInput.dealer.dealer_name.length > 0 then dealer_name = $scope.searchInput.dealer.dealer_name else dealer_name = null
        if $scope.searchInput.campaign && $scope.searchInput.campaign.campaign_name && $scope.searchInput.campaign.campaign_name.length > 0 then campaign_name = $scope.searchInput.campaign.campaign_name else campaign_name = null
        if $scope.searchInput.friendly_direction && $scope.searchInput.friendly_direction.length > 0 then friendly_direction = $scope.searchInput.friendly_direction.toLowerCase() else friendly_direction = null

        search_params = { dealer_name: dealer_name, campaign_name: campaign_name, friendly_direction: friendly_direction, friendly_from_number: $scope.searchInput.friendly_from_number, friendly_to_number: $scope.searchInput.friendly_to_number, friendly_duration: $scope.searchInput.friendly_duration }

        this.isLoading = true

        AgentReportService.getCalls.query({ page: this.current_page, agent_id: this.agentId, is4Minute: this.is4Minute, is_inbound: this.isInbound, is_outbound: this.isOutbound, search_params: search_params, is_searching: this.isSearching, start_date: $scope.searchInput.start_date, end_date: $scope.searchInput.end_date, sortBy: $scope.sortableControl.requestedSortBy(), sortableDirection: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.calls = responseData.calls
            $scope.requestControl.pagination = responseData.pagination
            $scope.requestControl.dateRange = responseData.date_range

            $scope.statsControl.totalCalls = responseData.stats.total_calls
            $scope.statsControl.averageCallLength = responseData.stats.average_call_length
            $scope.statsControl.inboundCalls = responseData.stats.inbound_calls
            $scope.statsControl.outboundCalls = responseData.stats.outbound_calls
            $scope.statsControl.callsOver4Minutes = responseData.stats.calls_over_4_min
            $scope.statsControl.surveysCompleted = responseData.stats.surveys_completed

            if $scope.requestControl.calls && $scope.requestControl.calls.length > 0
              index = 0
              _($scope.requestControl.calls.length).times ->

                if $scope.requestControl.calls[index].call_id && parseInt($scope.requestControl.calls[index].call_id, 10) > 0 && $scope.requestControl.calls[index].recording && $scope.requestControl.calls[index].recording.length > 0
                  mp3Player = getHorrendous($scope.requestControl.calls[index].call_id, $scope.requestControl.calls[index].recording)

                  $scope.requestControl.calls[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.requestControl.calls[index].mp3Player = null

                index += 1

          $scope.requestControl.isLoading = false
        )

    get4MinuteCalls: ->
      if this.agentId && parseInt(this.agentId, 10) > 0
        this.current_page = 1

        this.isInbound = false
        this.isOutbound = false
        this.is4Minute = true

        $scope.searchInput.friendly_duration = 240 # seconds

        this.getCalls()

    getInboundCalls: ->
      if this.agentId && parseInt(this.agentId, 10) > 0
        this.current_page = 1

        this.isInbound = true
        this.isOutbound = false
        this.is4Minute = false

        $scope.searchInput.friendly_direction = $scope.typeaheadControl.directions[0].direction

        this.getCalls()

    getOutboundCalls: ->
      if this.agentId && parseInt(this.agentId, 10) > 0

        this.current_page = 1   

        this.isInbound = false
        this.isOutbound = true
        this.is4Minute = false

        $scope.searchInput.friendly_direction = $scope.typeaheadControl.directions[1].direction

        this.getCalls()

    getTotalCalls: ->
      if this.agentId && parseInt(this.agentId, 10) > 0
        this.current_page = 1

        this.isInbound = false
        this.isOutbound = false
        this.is4Minute = false

        this.getCalls()

    performSearch: ->
      if $scope.searchInput.paramsCheck()
        this.isSearching = true

        this.current_page = 1

        this.getCalls()
      else
        this.isSearching = false

        gritterAdd("Please input the search parameters first.")

    resetCallToSendParams: ->
      this.callToSendId = null
      this.emailToSendRecording = null

    resetSearch: (doService) ->
      this.isSearching = false

      this.current_page = 1
      this.isInbound = false
      this.isOutbound = false
      this.is4Minute = false

      $scope.searchInput.resetParams()

      if doService
        this.getCalls()

    setSendCallRecordingId: (callId) ->
      if callId && parseInt(callId, 10) > 0
        this.callToSendId = callId

    verifyEmail: (email) ->
      expression = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      
      return expression.test(email)

    viewSurvey: (dealerId, surveyId) ->
      if dealerId && parseInt(dealerId, 10) > 0 && surveyId && parseInt(surveyId, 10) > 0
        window.open("/dealers/" + dealerId + '/surveys/' + surveyId, "_blank")

      return null

  }

################################################################
################# Surveys Completed Control ####################

  $scope.surveysCompletedControl = {

    current_page: 1

    isLoading: false

    pagination: null

    surveysCompleted: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getSurveysCompleted()

    getSurveysCompleted: ->
      if $scope.requestControl.agentId && parseInt($scope.requestControl.agentId, 10) > 0
        this.isLoading = true

        AgentReportService.getSurveysCompleted.query({ agent_id: $scope.requestControl.agentId, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.surveysCompletedControl.surveysCompleted = responseData.surveys
            $scope.surveysCompletedControl.pagination = responseData.pagination

            if $scope.surveysCompletedControl.surveysCompleted && $scope.surveysCompletedControl.surveysCompleted.length > 0
              index = 0
              _($scope.surveysCompletedControl.surveysCompleted.length).times ->

                if $scope.surveysCompletedControl.surveysCompleted[index].campaign_customer_id && parseInt($scope.surveysCompletedControl.surveysCompleted[index].campaign_customer_id, 10) > 0 && $scope.surveysCompletedControl.surveysCompleted[index].recording && $scope.surveysCompletedControl.surveysCompleted[index].recording.length > 0
                  mp3Player = getHorrendous($scope.surveysCompletedControl.surveysCompleted[index].campaign_customer_id, $scope.surveysCompletedControl.surveysCompleted[index].recording)

                  $scope.surveysCompletedControl.surveysCompleted[index].mp3Player = $sce.trustAsHtml(mp3Player)

                else
                  $scope.surveysCompletedControl.surveysCompleted[index].mp3Player = null

                index += 1

          $scope.surveysCompletedControl.isLoading = false
        )

  }

################################################################
################# Typeahead Control ############################

  $scope.typeaheadControl = {

    campaigns: []

    dealers: []

    directions: [{direction: "Inbound"}, {direction: "Outbound"}]

    from_numbers: []

    to_numbers: []

    getTypeaheadValues: ->
      if $scope.requestControl.agentId && parseInt($scope.requestControl.agentId, 10) > 0

        AgentReportService.getTypeaheadValues.query({ agent_id: $scope.requestControl.agentId }, (responseData) ->
          if responseData.errors == false
            $scope.typeaheadControl.dealers = responseData.dealers
            $scope.typeaheadControl.campaigns = responseData.campaigns
            $scope.typeaheadControl.to_numbers = responseData.to_numbers
            $scope.typeaheadControl.from_numbers = responseData.from_numbers
        )
  }

################################################################
################# Initialize ###################################

  init()

]
