surveyApp.factory 'NewSurveyService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getNextSurvey: ->
    deferred = $q.defer();
    $http.get('/get_next.json').then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  getDealershipInfo: (dealer_id) ->
    deferred = $q.defer();
    $http.get('/get_dealer_information.json?dealer_id=' + dealer_id).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  getDealershipPolicies: (dealer_id) ->
    deferred = $q.defer();
    $http.get('/get_dealer_policies.json?dealer_id=' + dealer_id).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  getCustomerServiceHistory: (campaign_customer_id) ->
    deferred = $q.defer();
    $http.get('/get_customer_service_history.json?campaign_customer_id=' + campaign_customer_id).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  getVehicleServiceHistory: (campaign_customer_id) ->
    deferred = $q.defer();
    $http.get('/get_vehicle_service_history.json?campaign_customer_id=' + campaign_customer_id).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  getCallHistory: (campaign_customer_id) ->
    deferred = $q.defer();
    $http.get('/get_call_history.json?campaign_customer_id=' + campaign_customer_id).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  updateSurveyCustomer: (customerId, key, value) ->
    deferred = $q.defer();

    query_params = 'customer_id=' + customerId + '&' + key + '=' + value 

    $http.get('/update_survey_customer.json?' + query_params).then (responseData) ->
      deferred.resolve(responseData)

    return deferred.promise

  saveSurvey: $resource "/create_survey.json", {}, query: { method: 'GET', isArray: false }

  callPark: $resource "/call_park.json", {}, query: { method: 'GET', isArray: false }

  callRecording: $resource "/call_recording.json", {}, query: { method: 'POST', isArray: false }

  createSurveyAttempt: $resource "/create_survey_attempt_2.json", {}, query: { method: 'GET', isArray: false }

  createSkipRecord: $resource "/skip_record.json", {}, query: { method: 'GET', isArray: false }

  createAgentWithStatus: $resource "/create_agent_with_status.json", {}, query: { method: 'GET', isArray: false }

  updateAgentStatus: $resource "/update_agent_status.json", {}, query: { method: 'GET', isArray: false }

  createBadNumber: $resource "/create_bad_number.json", {}, query: { method: 'GET', isArray: false }

  acceptImcomingCall: $resource "/incoming_call_2.json", {}, query: { method: 'GET', isArray: false }

  agentCallQueues: $resource "/agent_callqueues2.json", {}, query: { method: 'GET', isArray: false }

  agentUpdateCallQueue: $resource "/agent_update_call_queue_2.json", {}, query: { method: 'GET', isArray: false }

  agentUpdateAllCallQueues: $resource "/agent_update_all_call_queues_2.json", {}, query: { method: 'GET', isArray: false }

  enrollCustomer: $resource "/enroll_campaign_customer_2.json", {}, query: { method: 'GET', isArray: false }

  agentStatus: $resource "/get_agent_status.json", {}, query: { method: 'GET', isArray: false }

  createNewCustomer: $resource "/create_new_customer.json", {}, query: { method: 'GET', isArray: false }

  filterPreMatchCustomers: $resource "/filter_pre_match_customers.json", {}, query: { method: 'GET', isArray: false }

  getCallId: $resource "/new_outbound_call.json", {}, query: { method: 'GET', isArray: false }

  updateTwilioCall: $resource "/update_twilio_call.json", {}, query: { method: 'GET', isArray: false }

  outgoingCall: $resource "/outgoing_call.json", {}, query: { method: 'GET', isArray: false }

  incomingCall: $resource "/incoming_call.json", {}, query: { method: 'GET', isArray: false }

  getChildCalls: $resource "/get_child_calls.json", {}, query: { method: 'GET', isArray: false }

  terminateCall: $resource "/terminate_call_handler.json", {}, query: { method: 'GET', isArray: false }

]