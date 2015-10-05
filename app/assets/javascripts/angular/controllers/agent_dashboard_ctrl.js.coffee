surveyApp.controller 'AgentDashboardCtrl', ['$scope', '$http', 'AgentDashboardService', '$location', '$pusher', '$sce', ($scope, $http, AgentDashboardService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initializeAgentDashboard()
    initializeClocks()
    $scope.requestControl.getAgentDashboard()
    $scope.twilioDevice.getUserToken()
    $scope.pusherControl.initializePusher()

################################################################
############## Other Initializers ##############################

  initializeAgentDashboard = ->
    $scope.agentDashboard = {

      agents_on_calls: 0

      agents_waiting: 0

      average_hold_time: 0

      calls_waiting: 0

      calls_waiting_color_status: 'bg-success'

      idle_agents: 0

      idle_agents_color_status: 'bg-success'

      inbound_campaigns: 0

      longest_hold_time: 0

      online_agents: 0

      online_agents_color_status: 'bg-success'

      outbound_calls: 0

      outbound_campaigns: 0

      total_calls: 0
    }

  initializeClocks = ->
    $scope.averageHoldTimeControl.initializeClock()
    $scope.currentHoldTimeControl.initializeClock()

################################################################
################# Agents On Calls Control ######################

  $scope.agentsOnCallsControl = {

    agentsOnCalls: []

    isFetching: false

    getAgentsOnCalls: ->
      this.isFetching = true

      AgentDashboardService.getAgentsOnCalls.query({}, (responseData) ->
        if responseData.errors == false
          $scope.agentsOnCallsControl.agentsOnCalls = responseData.agents_on_calls
          $scope.agentDashboard.agents_on_calls = responseData.agents_on_calls_count
        else
          $scope.agentsOnCallsControl.agentsOnCalls = []
          $scope.agentDashboard.agents_on_calls = 0       

        $scope.agentsOnCallsControl.isFetching = false
      )

  }


################################################################
################# Agents Online Control ########################

  $scope.agentsOnlineControl = {

    agentsOnline: []

    isFetching: false

    getAgentsOnline: ->
      this.isFetching = true

      AgentDashboardService.getAgentsOnline.query({}, (responseData) ->
        if responseData.errors == false
          $scope.agentsOnlineControl.agentsOnline = responseData.agents_online
          $scope.agentDashboard.online_agents = responseData.agents_online_count
        else
          $scope.agentsOnlineControl.agentsOnline = []
          $scope.agentDashboard.online_agents = 0

        $scope.agentsOnlineControl.isFetching = false
      )

  }

################################################################
################# Agents Status Control ########################

  $scope.agentsStatusControl = {

    isRefreshing: false

    agents: []

    summary: null

    agentStatusRefresh: ->
      this.isRefreshing = true

      AgentDashboardService.agentStatusRefresh.query({}, (responseData) ->
        $scope.agentsStatusControl.agents = responseData.agents
        $scope.agentsStatusControl.summary = responseData.summary
        $scope.agentsStatusControl.isRefreshing = false
      )

  }

################################################################
################# Agents Waiting Control #######################

  $scope.agentsWaitingControl = {

    agentsWaiting: []

    isFetching: false

    getAgentsWaiting: ->
      this.isFetching = true

      AgentDashboardService.getAgentsWaiting.query({}, (responseData) ->
        if responseData.errors == false
          $scope.agentsWaitingControl.agentsWaiting = responseData.agents_waiting
          $scope.agentDashboard.agents_waiting = responseData.agents_waiting_count
        else
          $scope.agentsWaitingControl.agentsWaiting = []
          $scope.agentDashboard.agents_waiting = 0

        $scope.agentsWaitingControl.isFetching = false
      )

  }

################################################################
############## Average Hold Time Control #######################

  $scope.averageHoldTimeControl = {

    averageHoldTime: 0

    clock: null

    checkAverageHoldTime: ->
      if this.clock
        time = this.clock.getTime().time - 1

        if time >= 45
          return 'bg-danger'

        else if time >= 30
          return 'bg-warning'

        else
          return 'bg-success'

      return "bg-success"

    initializeClock: ->
      if $('#average_hold_time') && $('#average_hold_time').length > 0
        this.clock = $('#average_hold_time').FlipClock(1000,
          autoStart: false
          clockFace: 'MinuteCounter')

        this.setClockTime()

    setClockTime: ->
      if this.clock
        this.clock.setTime(this.averageHoldTime)

  }

################################################################
############## Current Hold Time Control #######################

  $scope.currentHoldTimeControl = {

    clock: null

    currentHoldTime: 0

    checkBoxColor: ->
      debugger;

    checkCurrentHoldTime: ->
      if this.clock && this.currentHoldTime > 0
        time = this.clock.getTime().time - 1

        if time >= 45
          return 'bg-danger'

        else if time >= 30
          return 'bg-warning'

        else
          return 'bg-success'

      return "bg-success"

    initializeClock: ->
      if $('#current_hold_time') && $('#current_hold_time').length > 0
        autoStart = if this.currentHoldTime > 0 then true else false

        this.clock = $('#current_hold_time').FlipClock(1000,
          autoStart: autoStart
          clockFace: 'MinuteCounter')

        this.setClockTime()

    setClockTime: ->
      if this.clock
        this.clock.setTime(this.currentHoldTime)

  }

################################################################
################### Idle Agents Control ########################

  $scope.idleAgentsControl = {

    idleAgents: []

    isFetching: false

    getIdleAgents: ->
      this.isFetching = true

      AgentDashboardService.getIdleAgents.query({}, (responseData) ->
        if responseData.errors == false
          $scope.idleAgentsControl.idleAgents = responseData.idle_agents
          $scope.agentDashboard.idle_agents = responseData.idle_agents_count
        else
          $scope.idleAgentsControl.idleAgents = []
          $scope.agentDashboard.idle_agents = 0

        $scope.idleAgentsControl.isFetching = false
      )

  }

################################################################
################# Inbound Calls Control ########################

  $scope.inboundCallsControl = {

    inboundCalls: []

    isFetching: false

    getInboundCalls: ->
      this.isFetching = true

      AgentDashboardService.getInboundCalls.query({}, (responseData) ->
        if responseData.errors == false
          $scope.inboundCallsControl.inboundCalls = responseData.inbound_calls
          $scope.agentDashboard.calls_waiting = responseData.inbound_calls_count
        else
          $scope.inboundCallsControl.inboundCalls = []
          $scope.agentDashboard.calls_waiting = 0

        $scope.inboundCallsControl.isFetching = false
      )

  }

################################################################
################# Inbound Campaigns Control ####################

  $scope.inboundCampaignsControl = {

    inboundCampaigns: []

    isRefreshing: false

    summary: null

    inboundCampaignsRefresh: ->
      this.isRefreshing = true

      AgentDashboardService.inboundCampaignsRefresh.query({}, (responseData) ->
        $scope.inboundCampaignsControl.inboundCampaigns = responseData.inbound_campaigns
        $scope.inboundCampaignsControl.summary = responseData.summary
        $scope.inboundCampaignsControl.isRefreshing = false
      )

    summaryCheck: ->
      if (this.inboundCampaigns && this.inboundCampaigns.length > 0 && this.summary != null) then true else false

  }

################################################################
################# Outbound Calls Control #######################

  $scope.outboundCallsControl = {

    isFetching: false

    outboundCalls: []

    getOutboundCalls: ->
      this.isFetching = true

      AgentDashboardService.getOutboundCalls.query({}, (responseData) ->
        if responseData.errors == false
          $scope.outboundCallsControl.outboundCalls = responseData.outbound_calls
          $scope.agentDashboard.outbound_calls = responseData.outbound_calls_count
        else
          $scope.outboundCallsControl.outboundCalls = []
          $scope.agentDashboard.outbound_calls = 0

        $scope.outboundCallsControl.isFetching = false
      )

  }

################################################################
################# Outbound Campaigns Control ###################

  $scope.outboundCampaignsControl = {

    isRefreshing: false

    outboundCampaigns: []

    summary: null

    outboundCampaignsRefresh: ->
      this.isRefreshing = true

      AgentDashboardService.outboundCampaignsRefresh.query({}, (responseData) ->
        $scope.outboundCampaignsControl.outboundCampaigns = responseData.outbound_campaigns
        $scope.outboundCampaignsControl.summary = responseData.summary
        $scope.outboundCampaignsControl.isRefreshing = false
      )

  }

################################################################
####################### Pusher Control #########################

  $scope.pusherControl = {

    initializePusher: ->
      AgentDashboardService.getPusherKey.query({}, (responseData) ->
        if responseData.errors == false
          client = new Pusher(responseData.api_key);
          pusher = $pusher(client);

          arccBroadcaseChannel = pusher.subscribe('broadcast-arcc')

          arccBroadcaseChannel.bind('push_call', (responseData) ->
            $scope.agentDashboard.calls_waiting = responseData.calls_waiting_count
            $scope.agentDashboard.calls_waiting_color_status = responseData.calls_waiting_color_status
          )

          arccBroadcaseChannel.bind('agent_status', (responseData) ->
            $scope.agentDashboard.online_agents = responseData.online_agents_count
            $scope.agentDashboard.online_agents_color_status = responseData.online_agents_color_status

            $scope.agentDashboard.idle_agents = responseData.idle_agents_count
            $scope.agentDashboard.idle_agents_color_status = responseData.idle_agents_color_status

            $scope.agentDashboard.agents_on_calls = responseData.agents_on_calls_count
            $scope.agentDashboard.agents_waiting = responseData.agents_waiting_count
          )

      )

  }

################################################################
################# Total Calls Control ##########################

  $scope.totalCallsControl = {

    current_page: 1

    isFetching: false

    pagination: null

    totalCalls: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getTotalCalls()

    getTotalCalls: ->
      this.isFetching = true

      AgentDashboardService.getTotalCalls.query({ page: this.current_page }, (responseData) ->
        if responseData.errors == false
          $scope.totalCallsControl.totalCalls = responseData.total_calls
          $scope.agentDashboard.total_calls = responseData.total_calls_count

          $scope.totalCallsControl.pagination = responseData.pagination

          if $scope.totalCallsControl.totalCalls && $scope.totalCallsControl.totalCalls.length > 0
            index = 0
            _($scope.totalCallsControl.totalCalls.length).times ->

              if $scope.totalCallsControl.totalCalls[index].call_id && parseInt($scope.totalCallsControl.totalCalls[index].call_id, 10) > 0 && $scope.totalCallsControl.totalCalls[index].recording && $scope.totalCallsControl.totalCalls[index].recording.length > 0
                mp3Player = getHorrendous($scope.totalCallsControl.totalCalls[index].call_id, $scope.totalCallsControl.totalCalls[index].recording)

                $scope.totalCallsControl.totalCalls[index].mp3Player = $sce.trustAsHtml(mp3Player)
              else
                $scope.totalCallsControl.totalCalls[index].mp3Player = null

              index += 1
        else
          $scope.totalCallsControl.totalCalls = []
          $scope.agentDashboard.total_calls = 0

        $scope.totalCallsControl.isFetching = false
      )

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    getAgentDashboard: ->
      AgentDashboardService.getAgentDashboard.query({}, (responseData) ->
        if responseData.errors == false
          $scope.agentDashboard = responseData.agent_dashboard

          $scope.averageHoldTimeControl.averageHoldTime = responseData.agent_dashboard.average_hold_time
          $scope.averageHoldTimeControl.initializeClock()

          $scope.currentHoldTimeControl.currentHoldTime = responseData.agent_dashboard.longest_hold_time
          $scope.currentHoldTimeControl.initializeClock()

          $scope.requestControl.setCallStatsInterval()

          $scope.inboundCampaignsControl.inboundCampaignsRefresh()
          $scope.agentsStatusControl.agentStatusRefresh()
          $scope.outboundCampaignsControl.outboundCampaignsRefresh()
      )

    downloadRecording: (call) ->
      if call && call.recording
        window.open(call.recording, "_blank")

      return null

    getCallStats: ->
      AgentDashboardService.getCallStats.query({}, (responseData) ->

        $scope.agentDashboard.outbound_calls = responseData.stats.outbound_calls_in_queue_count

        $scope.agentDashboard.total_calls = responseData.stats.total_calls_count

        $scope.averageHoldTimeControl.averageHoldTime = responseData.stats.average_hold_time
        $scope.averageHoldTimeControl.initializeClock()

        $scope.currentHoldTimeControl.currentHoldTime = responseData.stats.longest_hold_time
        $scope.currentHoldTimeControl.initializeClock()
      )

    setCallStatsInterval: ->
      callback = => this.getCallStats()

      setInterval(callback, 1000 * 10)

    viewCallDetails: (call_id) ->
      if call_id
        window.location = '/calls/' + call_id

    viewSurveyDetails: (dealer_id, survey) ->
      if dealer_id && survey && survey.id > 0
        window.location = '/dealers/' + dealer_id + '/surveys/' + survey.id

    viewUserDetails: (user_id) ->
      if user_id
        window.location = '/users/' + user_id

  }

################################################################
##################### Twilio Device ############################

  $scope.twilioDevice = {

    callId: null

    connection: null

    connection_outgoing: null

    isBarging: false

    isListening: false

    onPhoneCall: false

    userToken: null

    cancelCall: ->
      if Twilio.Device
        Twilio.Device.disconnectAll();

        console.log("Disconnected from the call.")

    bargeCall: (call_id) ->
      if call_id && call_id > 0 && Twilio.Device

        outgoing_params = { barge: true, listen: false, call_id: call_id }

        $scope.twilioDevice.connection_outgoing = Twilio.Device.connect(outgoing_params);

        $scope.twilioDevice.onPhoneCall = true

        $scope.twilioDevice.isBarging = true
        $scope.twilioDevice.isMuted = false

        $scope.twilioDevice.isListening = false

    getUserToken: ->
      this.reInitializeNotSetUp()

      AgentDashboardService.getUserToken.query({}, (responseData) ->
        if responseData.errors == false
          $scope.twilioDevice.userToken = responseData.user_token

          $scope.twilioDevice.initializeDevice()
      )

    initializeDevice: ->
      if this.userToken != null
        console.log("Setting up device")

        this.device = Twilio.Device.setup(this.userToken, {debug: false});
        
        if this.connection_outgoing
          this.connection_outgoing = null

    listenCall: (call_id) ->
      if call_id && call_id > 0 && Twilio.Device

        outgoing_params = { barge: false, listen: true, call_id: call_id }

        $scope.twilioDevice.connection_outgoing = Twilio.Device.connect(outgoing_params);

        $scope.twilioDevice.onPhoneCall = true

        $scope.twilioDevice.isListening = true
        $scope.twilioDevice.isMuted = true

        $scope.twilioDevice.isBarging = false

    mute: ->
      if this.isBarging && this.isBarging == true && this.connection != null

        this.connection.mute(true)

        # isMuted == true -> isBarging is false, isListening is true
        $scope.twilioDevice.isBarging = false
        $scope.twilioDevice.isListening = true

        gritterAdd("You are now Listening to the call.")

      return null

    reInitializeNotSetUp: ->
      this.callId = null
    
      this.connection_outgoing = null

      this.onPhoneCall = false
    
      this.userToken = null

    unMute: ->
      if this.isListening && this.isListening == true && this.connection != null

        this.connection.mute(false)

        # isMuted == false -> isBarging is true, isListening is false
        $scope.twilioDevice.isBarging = true
        $scope.twilioDevice.isListening = false

        gritterAdd("You have now barged the call.")

      return null

  } 

################################################################
################# Initialize ###################################

  init()

################################################################
################# Twilio Call Handlers #########################
  
  angular.element(document).ready ->

    Twilio.Device.ready (connection) ->
      console.log("inside the ready handler")

    Twilio.Device.connect (connection) ->
      console.log("inside the connect handler")

      $scope.twilioDevice.connection = connection

      if $scope.twilioDevice.isBarging && $scope.twilioDevice.isBarging == true
        gritterAdd("Successfully barged the call. The call is live.")

      if $scope.twilioDevice.isListening && $scope.twilioDevice.isListening == true
        gritterAdd("Successfully listening to the call. The call is live.")

    Twilio.Device.incoming (connection) ->
      console.log("inside the incoming handler")
      connection.accept()

      $scope.twilioDevice.onPhoneCall = true

    Twilio.Device.disconnect (connection) ->
      console.log("inside the disconnect handler")

      $scope.twilioDevice.onPhoneCall = false

      $scope.twilioDevice.connection_outgoing = null
      $scope.twilioDevice.isBarging = false
      $scope.twilioDevice.isListening = false
      $scope.twilioDevice.connection = null

    Twilio.Device.presence (presenceEvent) ->
      console.log("presenceEvent available = " + presenceEvent.available)

]
