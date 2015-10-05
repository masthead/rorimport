surveyApp.controller 'NewSurveyCtrl', ['$scope', '$http', 'NewSurveyService', 'CustomerSearchService', '$location', ($scope, $http, NewSurveyService, CustomerSearchService, $location) ->

###########################################################
############## Initial Page Load / Reset ##################

  init = ->
    hideWarnings();

    $scope.initializeObjects()
    $scope.ahoyControl.setVisitId()
    $scope.newAttempts = []

    $scope.sidrModalControl.initializeSidr();

    if ($scope.landingControl.isQueueSelection == false)
      $scope.requestControl.getNextSurvey();
    else
      $scope.callQueuesControl.agentCallQueues();

    $scope.appointmentDatepicker.toggleMin();
    $scope.callbackDatepicker.toggleMin();

    $scope.phoneKeyPad.ininializeKeys();

###########################################################
############## Other Initializers #########################

  findAgentStatusIndex = ->
    next_index = 0
    desired_index = (-1)
    _($scope.agentStatus.agent_statuses.length).times ->
      if $scope.agentStatus.agent_statuses[next_index].id == $scope.agentStatus.current_agent_status.id
        desired_index = next_index

      next_index += 1

    return desired_index

  getAgentStatus = ->
    desired_index = findAgentStatusIndex()

    if desired_index >= 0
      return $scope.agentStatus.agent_statuses[desired_index]
    else
      return null

  hideWarnings = ->
    $('#customer_search_row_2').hide()
    $('#required_questions_remain').hide()
    $('#status-ready').hide()

  $scope.initializeObjects = ->
    initializeNewCustomer()
    initializeNewSurvey()
    initializeNewSurveyAnswer()
    initializeNewTransaction()
    initializeNewVehicle()
    initializeAgentStatus()
    $scope.surveyQuestionsControl.resetNew()

  initializeAgentStatus = ->
    $scope.agentStatus = null

  initializeNewCustomer = ->
    $scope.newCustomer = null

  initializeNewSurvey = ->
    $scope.newSurvey = null

  initializeNewSurveyAnswer = ->
    $scope.surveyAnswer = {
      survey_template_question_id: 0,
      survey_answer: '',
      send_survey: false,
      required: false,
      question_type: ''
    }

  initializeNewTransaction = ->
    $scope.newTransaction = {
      timestamp: '',
      type: '',
      transaction_number: ''
    }

  initializeNewVehicle = ->
    $scope.newVehicle = {
      vin: '',
      year: '',
      make: '',
      model: '',
      sold_date: '',
      last_service_date: '',
      previous_service_visit: '',
      last_odometer: '',
      estimated_current_odometer: ''
    }

  $scope.initializeWatchForChanges = ->
    $scope.watchForChanges = {

      customer_id: if $scope.newCustomer then $scope.newCustomer.customer_id else null

      do_not_contact_flag: if $scope.newCustomer then $scope.newCustomer.do_not_contact_flag else null

      first_name: if $scope.newCustomer then $scope.newCustomer.first_name else null

      last_name: if $scope.newCustomer then $scope.newCustomer.last_name else null

      cell_phone: if $scope.newCustomer then $scope.newCustomer.cell_phone else null

      home_phone: if $scope.newCustomer then $scope.newCustomer.home_phone else null

      work_phone: if $scope.newCustomer then $scope.newCustomer.work_phone else null

      email_address_1: if $scope.newCustomer then $scope.newCustomer.email_address_1 else null

      current_agent_status: if $scope.agentStatus then getAgentStatus() else null

    }

  $scope.ahoyControl = {

    visitId: null

    setVisitId: ->
      if ahoy
        this.visitId = ahoy.getVisitId()
  }

###########################################################
################# Agent Status Control ####################

  $scope.agentStatusControl = {

    paused: false

    createAgentWithStatus: (status_name) ->
      NewSurveyService.createAgentWithStatus.query({ campaign_customer_id: $scope.newCustomer.campaign_customer_id, status_name: status_name }, (responseData) ->

        if responseData.errors == false
          console.log("Properly created agent with status - " + responseData.status_name)

        else
          console.log("Something went wrong with agent status creation")
      )

    pauseAgent: ->
      this.paused = true

      this.createAgentWithStatus("Pause CampaignCustomer")

    resumeAgent: ->
      this.paused = false

      this.createAgentWithStatus("Resume CampaignCustomer")

    wrapUpAgent: ->
      this.paused = false

      this.createAgentWithStatus("Wrap Up")

  }

###########################################################
################# Bad Numbers Control #####################

  $scope.badNumbersControl = {

    selectedPhoneNumber: null

    cancelBadNumber: ->
      this.selectedPhoneNumber = null

    checkForBadNumber: (phone_number) ->
      if $scope.newCustomer[phone_number + '_valid'] == false && $scope.newCustomer[phone_number] == null
        return true
      else if $scope.newCustomer[phone_number + '_valid'] == false && $scope.newCustomer[phone_number] != null && $scope.newCustomer[phone_number].length > 0
        return false
      else
        return true

    createBadNumber: ->
      if this.selectedPhoneNumber != null
        NewSurveyService.createBadNumber.query({ phone_number: $scope.newCustomer[$scope.badNumbersControl.selectedPhoneNumber], customer_id: $scope.newCustomer.customer_id }, (responseData) -> 
          if responseData.errors == false

            $scope.newCustomer[$scope.badNumbersControl.selectedPhoneNumber + "_valid"] = false

          $scope.badNumbersControl.selectedPhoneNumber = null
        )

    setUpBadNumberConfirmation: (phone_number) ->
      this.selectedPhoneNumber = phone_number

  }

###########################################################
################# Call Queues Search ######################

  $scope.callQueuesControl = {

    availableCallQueues: []

    isFetchingCallQueues: false

    loggedInCallQueues: []

    selectedCallQueue: null

    addAllCallQueues: ->
      if this.availableCallQueues && this.availableCallQueues.length == 0
        return null
      else
        NewSurveyService.agentUpdateCallQueue.query({ user_action: 'logged_in', call_queue_id: this.availableCallQueues[0].id }, (responseData) ->
          if responseData.errors == false
            selectedCallQueue = $scope.callQueuesControl.availableCallQueues[0]
            
            $scope.callQueuesControl.availableCallQueues.splice(0, 1)

            $scope.callQueuesControl.loggedInCallQueues.push(selectedCallQueue)

            $scope.callQueuesControl.addAllCallQueues()
        )

    addSelectedCallQueue: ->
      NewSurveyService.agentUpdateCallQueue.query({ user_action: 'logged_in', call_queue_id: this.selectedCallQueue[0].id }, (responseData) ->
        if responseData.errors == false
          selectedsIndex = $scope.callQueuesControl.availableCallQueues.indexOf($scope.callQueuesControl.selectedCallQueue[0])
          $scope.callQueuesControl.availableCallQueues.splice(selectedsIndex, 1)

          $scope.callQueuesControl.loggedInCallQueues.push($scope.callQueuesControl.selectedCallQueue[0])
      )

    agentCallQueues: ->
      this.isFetchingCallQueues = true

      NewSurveyService.agentCallQueues.query({}, (responseData) ->
        if responseData.errors == false
          $scope.callQueuesControl.availableCallQueues = responseData.available_call_queues
          $scope.callQueuesControl.loggedInCallQueues = responseData.logged_in_call_queues
        
        $scope.callQueuesControl.isFetchingCallQueues = false
      )

    displayCallQueueOption: (callQueue) ->
      return callQueue.call_queue_name + ' (' + callQueue.remaining + ')'

    removeAllCallQueues: ->
      if this.loggedInCallQueues && this.loggedInCallQueues.length == 0
        return null
      else
        NewSurveyService.agentUpdateCallQueue.query({ user_action: 'logged_out', call_queue_id: this.loggedInCallQueues[0].id }, (responseData) ->
          if responseData.errors == false
            selectedCallQueue = $scope.callQueuesControl.loggedInCallQueues[0]
            
            $scope.callQueuesControl.loggedInCallQueues.splice(0, 1)

            $scope.callQueuesControl.availableCallQueues.push(selectedCallQueue)

            $scope.callQueuesControl.removeAllCallQueues()
        )

    removeSelectedCallQueue: ->
      NewSurveyService.agentUpdateCallQueue.query({ user_action: 'logged_out', call_queue_id: this.selectedCallQueue[0].id }, (responseData) ->
        if responseData.errors == false
          selectedsIndex = $scope.callQueuesControl.loggedInCallQueues.indexOf($scope.callQueuesControl.selectedCallQueue[0])
          $scope.callQueuesControl.loggedInCallQueues.splice(selectedsIndex, 1)

          $scope.callQueuesControl.availableCallQueues.push($scope.callQueuesControl.selectedCallQueue[0])
      )

  }

###########################################################
################# Customer Search #########################

  $scope.customerSearchControl = {

    address: null

    dealer_id: null

    email: null

    first_name: null

    isSearching: false

    last_name: null

    phone_number: null

    searchedCustomers: []

    vin: null

    filteredAddress: ->
      angular.lowercase(this.address)

    filteredEmail: ->
      angular.lowercase(this.email)

    filteredFirstName: ->
      angular.lowercase(this.first_name)

    filteredLastName: ->
      angular.lowercase(this.last_name)

    filteredPhoneNumber: ->
      this.phone_number

    reInitialize: ->
      this.address = null
      this.dealer_id = null
      this.email = null
      this.first_name = null
      this.last_name = null
      this.phone_number = null
      this.vin = null

      this.resetCustomers()

    resetCustomers: ->
      this.searchedCustomers = []

    searchCustomers: ->
      this.resetCustomers()

      this.isSearching = true

      CustomerSearchService.searchCustomers.query({ dealer_id: this.dealer_id, first_name: this.filteredFirstName(), last_name: this.filteredLastName(), customer_email: this.filteredEmail(), customer_phone: this.filteredPhoneNumber(), customer_address: this.filteredAddress(), vin: this.vin }, (responseData) ->
        if responseData.errors == false
          $scope.customerSearchControl.searchedCustomers = responseData.search_results

        $scope.customerSearchControl.isSearching = false
      )
  }

###########################################################
################# Datepickers #############################

  $scope.appointmentDatepicker = {

    dateOptions: {
      formatYear: 'yy',
      startingDay: 1,
      showWeeks: false
    };

    format: 'dd-MMMM-yyyy';

    minDate: new Date()

    opened: false

    clear: ->
      $scope.surveyDispositionsControl.selectedAppointmentDate = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.surveyDispositionsControl.selectedAppointmentDate == null
        this.today()

      $scope.appointmentDatepicker.opened = true;

    today: ->
      $scope.surveyDispositionsControl.selectedAppointmentDate = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

  $scope.callbackDatepicker = {

    dateOptions: {
      formatYear: 'yy',
      startingDay: 1,
      showWeeks: false
    };

    format: 'dd-MMMM-yyyy';

    minDate: new Date()

    opened: false

    clear: ->
      $scope.surveyDispositionsControl.selectedCallbackDate = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.surveyDispositionsControl.selectedCallbackDate == null
        this.today()

      $scope.callbackDatepicker.opened = true;

    today: ->
      $scope.surveyDispositionsControl.selectedCallbackDate = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

###########################################################
################# Edit Control ############################

  $scope.editControl = {

    currentKey: null

    do_not_contact_flag: null

    editingCellPhone: false

    editingDoNotContactFlag: false
    
    editingEmailAddress: false
    
    editingFirstName: false

    editingHomePhone: false
    
    editingLastName: false

    editingWorkPhone: false

    returnKeyValue: 13

    eventKeypress: ($event, id, key) ->
      if $event.charCode == this.returnKeyValue
        this.updateCustomerInfo(id, key)

    setDoNotContactFlagOn: ->
      if $scope.watchForChanges
        $scope.watchForChanges.do_not_contact_flag = true

        this.updateCustomerInfo('doNotContactFlag', 'do_not_contact_flag')

    setToEdit: (id) ->
      this[id] = true

    updateCustomerInfo: (id, key) ->
      this[id] = false

      this.currentKey = key

      promise = NewSurveyService.updateSurveyCustomer($scope.watchForChanges.customer_id, key, $scope.watchForChanges[key])

      promise.then((responseData) ->
        if responseData.data.errors == false && $scope.editControl.currentKey && $scope.editControl.currentKey.length > 0
          $scope.newCustomer[$scope.editControl.currentKey] = $scope.watchForChanges[$scope.editControl.currentKey]
          $scope.editControl.currentKey = null  

          # Need to update the valid phone numbers after updating
          $scope.newCustomer.cell_phone_valid = responseData.data.customer.cell_phone_valid
          $scope.newCustomer.home_phone_valid = responseData.data.customer.home_phone_valid     
          $scope.newCustomer.work_phone_valid = responseData.data.customer.work_phone_valid       
      )
  }

###########################################################
################# Hide Control ############################

  $scope.hideControl = {

    isHiding: false

    hideInfo: ->
      if $('#customer_info_tray')
        $('#customer_info_tray')[0].style.display = 'none';

        this.isHiding = true

    showInfo: ->
      if $('#customer_info_tray')
        $('#customer_info_tray')[0].style.display = 'block';

        this.isHiding = false

  }

###########################################################
########### Incoming Pre-Match Customers ##################

  $scope.incomingCustomersModalControl = {

    campaign_id: null

    customerVin: null

    filterName: null

    isEnrolling: false

    newCustomer: null

    preMatchCustomers: []

    pusher_call_id: null

    createCustomer: ->
      if this.campaign_id && parseInt(this.campaign_id, 10) > 0
        this.isEnrolling = true

        NewSurveyService.createNewCustomer.query({ campaign_id: this.campaign_id, customer: this.newCustomer, vin: this.customerVin }, (responseData) ->
          if responseData.errors == false
            $scope.incomingCustomersModalControl.enrollCustomer(responseData.customer.id, responseData.vehicle_id)
        )

    enrollCustomer: (customer_id, vehicle_id) ->
      if this.campaign_id && parseInt(this.campaign_id, 10) > 0
        this.isEnrolling = true

        NewSurveyService.enrollCustomer.query({ campaign_id: this.campaign_id, customer_id: customer_id, vehicle_id: vehicle_id }, (responseData) ->
          if responseData.errors == false
            $scope.message = responseData.data.message

            if $scope.message != "No more customers in queue"
              $scope.newCustomer = responseData.data.customer
              $scope.newVehicle = responseData.data.vehicle
              $scope.newTransaction = responseData.data.transaction
              $scope.newSurvey = responseData.data.survey
              $scope.newAttempts = responseData.data.attempts

              $scope.initializeWatchForChanges()

              $location.search('campaign_customer_id=' + $scope.newCustomer.campaign_customer_id)
          
              if $scope.newSurvey.questions && $scope.newSurvey.questions.length > 0
                $scope.surveyQuestionsControl.createSurveyAnswers()

              $scope.agentStatusControl.createAgentWithStatus("Start CampaignCustomer")

          $scope.incomingCustomersModalControl.isEnrolling = false
          $scope.incomingCustomersModalControl.properlyCloseModal()
        )

    filterPreMatch: ->
      if this.pusher_call_id
        NewSurveyService.filterPreMatchCustomers.query({ pusher_call_id: this.pusher_call_id, filter_name: this.filterName }, (responseData) ->
          if responseData.errors == false
            $scope.incomingCustomersModalControl.preMatchCustomers = responseData.filtered_pre_match_customers
        )

    properlyCloseModal: ->
      this.campaign_id = null
      this.preMatchCustomers = []
      this.pusher_call_id = null

      $scope.customerSearchControl.reInitialize()

      this.switchPreMatchTab()
      $('#incoming_customer_search .close').click()

    resetPreMatch: ->
      this.filterName = null

      this.filterPreMatch()

    setUpNewCustomer: ->
      this.newCustomer = {
        cell_phone: $('#incoming_customer_phone_number')[0].value
      }

      return null

    switchPreMatchTab: ->
      if $('#incoming_customer_search') && $('#incoming_customer_search').length > 0 && $('#incoming_customer_search').hasClass("in")
        $('#pre-match-tab').click()

      null

    switchAdvancedSearchTab: ->
      if $('#incoming_customer_search') && $('#incoming_customer_search').length > 0 && $('#incoming_customer_search').hasClass("in")
        $('#advanced-customer-search-tab').click()

      null

    switchNewCustomerTab: ->
      if $('#incoming_customer_search') && $('#incoming_customer_search').length > 0 && $('#incoming_customer_search').hasClass("in")
        $('#new-customer-tab').click()

      null
  }

###########################################################
################# Landing Control #########################

  $scope.landingControl = {

    isQueueSelection: true

    closeCallQueueSelection: ->
      this.isQueueSelection = false

      init()

    openCallQueueSelection: ->
      this.isQueueSelection = true

  }

###########################################################
################# Loader Control ##########################

  $scope.loaderControl = {

    loaderActive: false

    hideLoader: ->
      this.loaderActive = false
    
    showLoader: ->
      this.loaderActive = true

  }

###########################################################
################# Phone Key Pad ###########################

  $scope.phoneKeyPad = {

    keys: []

    number: ''

    numberKeysPerRow: 3

    oneInsideNumbers: ''

    oneRemainingThree: ''

    oneRemainingFour: ''
    
    startsWithOne: false
    
    totalRows: null

    backKeyPress: ->

      if this.startsWithOne == true
        if this.oneInsideNumbers.length > 0 && this.oneRemainingThree.length == 0 && this.oneRemainingFour.length == 0
          this.oneInsideNumbers = this.oneInsideNumbers.slice(0, -1)
        else if this.oneRemainingThree.length > 0 && this.oneRemainingFour.length == 0
          this.oneRemainingThree = this.oneRemainingThree.slice(0, -1)
        else
          this.oneRemainingFour = this.oneRemainingFour.slice(0, -1)

        if this.oneRemainingFour.length > 4
          this.number = '1' + this.oneInsideNumbers + this.oneRemainingThree + this.oneRemainingFour
        else if this.oneRemainingFour.length > 0 && this.oneRemainingFour.length < 5
          this.number = '1 (' + this.oneInsideNumbers + ') ' + this.oneRemainingThree + '-' + this.oneRemainingFour
        else
          this.number = '1 (' + this.oneInsideNumbers + ') ' + this.oneRemainingThree

        if $scope.phoneKeyPad.number.length == 5
          this.number = ''

      else

        this.number = this.number.slice(0, -1)

        if this.number[this.number.length - 1] == '-'
          this.number = this.number.slice(0, -1)

        if this.number.length == 11 && this.number.indexOf("(") != (-1) && this.number.indexOf(")") != (-1) && this.number.indexOf(" ") != (-1) && this.number.indexOf("-") != (-1)
          this.number = this.number.replace("(", "").replace(")", "").replace(" ", "").replace("-", "")

          area_code = this.number.slice(0, 3)

          remaining = this.number.slice(3, this.number.length)

          this.number = area_code + '-' + remaining

        if this.number.length == 10
          area_code = this.number.slice(0, 3)

          next_three = this.number.slice(3, 6)

          remaining = this.number.slice(6, this.number.length)

          this.number = '(' + area_code + ') ' + next_three + '-' + remaining

      if this.number.length == 0
        this.startsWithOne = false

    ininializeKeys: ->
      
      this.keys.push( { value: 1, letters: null } )
      this.keys.push( { value: 2, letters: 'ABC' } )
      this.keys.push( { value: 3, letters: 'DEF' } )
      this.keys.push( { value: 4, letters: 'GHI' } )
      this.keys.push( { value: 5, letters: 'JKL' } )
      this.keys.push( { value: 6, letters: 'MNO' } )
      this.keys.push( { value: 7, letters: 'PQRS' } )
      this.keys.push( { value: 8, letters: 'TUV' } )
      this.keys.push( { value: 9, letters: 'WXYZ' } )
      this.keys.push( { value: '*', letters: null } )
      this.keys.push( { value: 0, letters: '+' } )
      this.keys.push( { value: '#', letters: null } )

      this.totalRows = Math.round(this.keys.length / this.numberKeysPerRow)

      this.keyRows = this.setUpRows(this.keys)

    keyPress: (key) ->

      if this.startsWithOne == true

        if this.oneInsideNumbers.length >= 3

          if this.oneRemainingThree.length == 3
            this.oneRemainingFour += key.value

          else
            this.oneRemainingThree += key.value

        else if this.oneInsideNumbers.length < 3
          this.oneInsideNumbers += key.value

        else
          this.oneRemainingFour += key.value

        if this.oneRemainingFour.length > 4
          this.number = '1' + this.oneInsideNumbers + this.oneRemainingThree + this.oneRemainingFour

        else if this.oneRemainingFour.length > 0 && this.oneRemainingFour.length < 5
          this.number = '1 (' + this.oneInsideNumbers + ') ' + this.oneRemainingThree + '-' + this.oneRemainingFour

        else
          this.number = '1 (' + this.oneInsideNumbers + ') ' + this.oneRemainingThree

      else

        if this.number.length <= 2 && this.number.indexOf('-') != (-1)
          this.number.replace('-', '')

        if this.number.length == 3 && this.number.indexOf('-') != (3) 
          this.number += '-'

        if this.number.length == 8
          this.number = this.number.replace("-", "")

          area_code = this.number.slice(0, 3)

          next_three = this.number.slice(3, this.number.length - 1)

          remaining = this.number.slice(this.number.length - 1, this.number.length)

          this.number = '(' + area_code + ') ' + next_three + '-' + remaining

        if this.number.length > 13
          this.number = this.number.replace("(", "").replace(")", "").replace(" ", "").replace("-", "")

        this.number += key.value

      if this.number.length == 1 && key.value == 1
        this.startsWithOne = true

    setUpRows: (availableKeys) ->
      allRows = []

      _(this.totalRows).times ->
        row = []

        _($scope.phoneKeyPad.numberKeysPerRow).times ->
          row.push(availableKeys.shift())

        allRows.push(row)

      return allRows

  }

###########################################################
################# Request Control #########################

  $scope.requestControl = {

    saveAndNextSurvey: false

    createSurveyAttempt: ->
      $scope.surveyDispositionsControl.resetDispositionsForSurveyAttemptCreate()
      
      disposition = $scope.surveyDispositionsControl.selectedDisposition

      if $scope.surveyDispositionsControl.selectedEmployee && $scope.surveyDispositionsControl.selectedEmployee.employee_id > 0
        employee_id = $scope.surveyDispositionsControl.selectedEmployee.employee_id
      else
        employee_id = null

      if $scope.surveyDispositionsControl.selectedDepartment && $scope.surveyDispositionsControl.selectedDepartment.department_id
        department_id = $scope.surveyDispositionsControl.selectedDepartment.department_id
      else
        department_id = null

      app_date = $scope.surveyDispositionsControl.selectedAppointmentDate
      app_time = $scope.surveyDispositionsControl.selectedAppointmentTime
      callback_date = $scope.surveyDispositionsControl.selectedCallbackDate
      callback_time = $scope.surveyDispositionsControl.selectedCallbackTime
      callback_notes = $scope.surveyDispositionsControl.selectedCallbackNotes

      if $scope.newVehicle && $scope.newVehicle.vin
        vin = $scope.newVehicle.vin
      else
        vin = null

      NewSurveyService.createSurveyAttempt.query({ disposition: disposition, employee_id: employee_id, department_id: department_id, appointment_date: app_date, appointment_time: app_time, callback_date: callback_date, callback_time: callback_time, callback_notes: callback_notes, call_id: $scope.twilioDevice.callId, campaign_customer_id: $scope.newCustomer.campaign_customer_id, vin: vin }, (responseData) ->

        if $scope.requestControl.saveAndNextSurvey == true && responseData.survey_attempt_id && parseInt(responseData.survey_attempt_id, 10) > 0
          console.log("Attempt created 1.")

          $scope.requestControl.saveSurvey(responseData.survey_attempt_id, responseData.appointment_id)

        else if responseData.errors == false
          console.log("Attempt created 2.")
        else
          console.log("Error!")

        $scope.surveyDispositionsControl.resetDispositionsToDefault()
      )

    getNextSurvey: ->
      $scope.loaderControl.showLoader()

      promise = NewSurveyService.getNextSurvey()

      promise.then((responseData) ->

        $scope.message = responseData.data.message
        # $scope.message = "No more customers in queue"

        if $scope.message != "No more customers in queue"
          $scope.newCustomer = responseData.data.customer
          $scope.newVehicle = responseData.data.vehicle
          $scope.newTransaction = responseData.data.transaction
          $scope.newSurvey = responseData.data.survey
          $scope.agentStatus = responseData.data.agent_status
          $scope.newAttempts = responseData.data.attempts

          $scope.initializeWatchForChanges()

          $location.search('campaign_customer_id=' + $scope.newCustomer.campaign_customer_id)
          
          if $scope.newSurvey.questions && $scope.newSurvey.questions.length > 0
            $scope.surveyQuestionsControl.createSurveyAnswers()

          $scope.twilioDevice.initializeDevice()

          $scope.agentStatusControl.createAgentWithStatus("Start CampaignCustomer")

          $scope.loaderControl.hideLoader()
        else
          # Reinitialize Everything to null
          NewSurveyService.agentStatus.query({}, (responseData) ->
            if responseData.errors == false
              $scope.initializeObjects()

              # Update the agent status objects
              $scope.agentStatus = responseData.agent_status
              $scope.initializeWatchForChanges()

              $scope.loaderControl.hideLoader()
          )
      )

    logOut: ->
      window.location = '/log_out'

    goHome: ->
      window.location = '/'

    reInit: ->
      init();

    saveSurvey: (survey_attempt_id, appointment_id) ->
      survey_answers = $scope.surveyQuestionsControl.formatSurveyAnswers()

      NewSurveyService.saveSurvey.query campaign_customer_id: $scope.newCustomer.campaign_customer_id, survey_answers: survey_answers, survey_attempt_id: survey_attempt_id, survey_notes: $scope.surveyQuestionsControl.survey_notes, appointment_date: $scope.surveyDispositionsControl.selectedAppointmentDate, appointment_time: $scope.surveyDispositionsControl.selectedAppointmentTime, appointment_id: appointment_id, (responseData) -> 
        console.log("Created Survey")

        $scope.agentStatusControl.createAgentWithStatus("Finished CampaignCustomer")

        $scope.requestControl.reInit()

    updateAgentStatus: ->
      if $scope.watchForChanges.current_agent_status && $scope.watchForChanges.current_agent_status.id != $scope.agentStatus.current_agent_status.id
        NewSurveyService.updateAgentStatus.query({ agent_status_id: $scope.watchForChanges.current_agent_status.id }, (responseData) ->
          if responseData.errors == false
            $scope.agentStatus.current_agent_status = $scope.watchForChanges.current_agent_status
          else
            console.log("Something went wrong.")
        )

    updateSaveAndNextSurvey: ->
      this.saveAndNextSurvey = true

      this.createSurveyAttempt()

  }

###########################################################
################# Sidr / Modal Control ####################

  $scope.sidrModalControl = {

    callHistory: []
    
    customerServiceHistory: []
    
    dealerInformation: null
    
    dealerPolicies: null
    
    dispositionRows: []
    
    fetchingCallHistory: true
    
    fetchingCustomerServiceHistory: true
    
    fetchingDealerInformation: true
    
    fetchingDealerPolicies: true
    
    fetchingVehicleServiceHistory: true
    
    isOpen: false
    
    numberDispositionsPerRow: 4
    
    totalRows: null

    vehicleServiceHistory: []

    closeOpenModal: (clickedModal) ->
      if $('.modal.in') && $('.modal.in').length > 0
        $('.modal.in').find('.close').click()

      if clickedModal == 'nextSurvey'

        this.setUpNextSurveyModal()

      if clickedModal == 'skipRecord'

        this.setUpSkipRecord()

    initializeSidr: ->
      $('#left-menu').sidr({
        name: 'sidr-left',
        side: 'left'
      });

    reinitializeModalContent: ->
      this.dealerInformation = null
      this.fetchingDealerInformation = true

      this.dealerPolicies = null
      this.fetchingDealerPolicies = true

      this.vehicleServiceHistory = []
      this.fetchingVehicleServiceHistory = true

      this.customerServiceHistory = []
      this.fetchingCustomerServiceHistory = true

      this.callHistory = []
      this.fetchingCallHistory = true

    setUpCallHistoryModal: ->
      this.closeOpenModal('callHistoryModal')

      if this.callHistory && this.callHistory.length == 0 && $scope.newCustomer.campaign_customer_id && parseInt($scope.newCustomer.campaign_customer_id, 10) > 0
        promise = NewSurveyService.getCallHistory($scope.newCustomer.campaign_customer_id)

        promise.then((responseData) ->
          $scope.sidrModalControl.callHistory = responseData.data.survey_attempts
          $scope.sidrModalControl.fetchingCallHistory = false
        )

    setUpCustomerServiceHistoryModal: ->
      this.closeOpenModal('customerServiceHistoryModal')

      if this.customerServiceHistory && this.customerServiceHistory.length == 0 && $scope.newCustomer.campaign_customer_id && parseInt($scope.newCustomer.campaign_customer_id, 10) > 0
        promise = NewSurveyService.getCustomerServiceHistory($scope.newCustomer.campaign_customer_id)

        promise.then((responseData) ->
          $scope.sidrModalControl.customerServiceHistory = responseData.data.service_history
          $scope.sidrModalControl.fetchingCustomerServiceHistory = false
        )

    setUpDealershipInfoModal: ->
      this.closeOpenModal('dealershipInfoModal')

      if this.dealerInformation == null && $scope.newCustomer.dealer_id && parseInt($scope.newCustomer.dealer_id, 10) > 0
        promise = NewSurveyService.getDealershipInfo($scope.newCustomer.dealer_id)

        promise.then((responseData) ->
          if responseData.data.dealer_information
            $scope.sidrModalControl.dealerInformation = responseData.data.dealer_information
            $scope.sidrModalControl.fetchingDealerInformation = false
        )

    setUpDealershipPoliciesModal: ->
      this.closeOpenModal('dealershipPoliciesModal')

      if $scope.newCustomer.dealer_id && parseInt($scope.newCustomer.dealer_id, 10) > 0
        promise = NewSurveyService.getDealershipPolicies($scope.newCustomer.dealer_id)

        promise.then((responseData) ->
          if responseData.data.dealer_information
            $scope.sidrModalControl.dealerPolicies = responseData.data.dealer_information
            $scope.sidrModalControl.fetchingDealerPolicies = false
        )

    setUpNextSurveyModal: ->
      if $('#left-menu') && $('.sidr-open.sidr-left-open') && $('.sidr-open.sidr-left-open').length > 0
        $('#left-menu').click()

      if $scope.sidrModalControl.dispositionRows.length == 0

        this.totalRows = Math.ceil($scope.newSurvey.dispositions.length / this.numberDispositionsPerRow)

        this.dispositionRows = this.setUpRows($scope.newSurvey.dispositions);

      return null

    setUpRows: (availableDispositions) ->
      allRows = []

      _(this.totalRows).times ->
        row = []

        _($scope.sidrModalControl.numberDispositionsPerRow).times ->
          disposition = availableDispositions.shift()

          if disposition
            row.push(disposition)
          else
            row.push({disposition_name: ""})

        allRows.push(row)

      return allRows

    setUpSkipRecord: ->
      if $('#left-menu') && $('.sidr-open.sidr-left-open') && $('.sidr-open.sidr-left-open').length > 0
        $('#left-menu').click()

      return null

    setUpVehicleServiceHistoryModal: ->
      this.closeOpenModal('vehicleServiceHistoryModal')

      if this.vehicleServiceHistory && this.vehicleServiceHistory.length == 0 && $scope.newCustomer.campaign_customer_id && parseInt($scope.newCustomer.campaign_customer_id, 10) > 0
        promise = NewSurveyService.getVehicleServiceHistory($scope.newCustomer.campaign_customer_id)

        promise.then((responseData) ->
          $scope.sidrModalControl.vehicleServiceHistory = responseData.data.service_history
          $scope.sidrModalControl.fetchingVehicleServiceHistory = false
        )

  }

###########################################################
################# Skip Record Control #####################

  $scope.skipRecordControl = {

    notes: null

    createSkipRecord: ->
      $scope.loaderControl.showLoader()

      NewSurveyService.createSkipRecord.query({ campaign_customer_id: $scope.newCustomer.campaign_customer_id, notes: $scope.skipRecordControl.notes }, (responseData) ->
        if responseData.errors == false
          console.log("Skip record created successfully. Creating agent with status..")

          $scope.agentStatusControl.createAgentWithStatus("Finished CampaignCustomer")

          console.log("Resetting page..")

          init();
      )

  }

###########################################################
################# Call Status Control #####################

  $scope.statusControl = {

    statusWaiting: true

    setStatusCallReady: ->
      this.statusWaiting = false

    setStatusCallWaiting: ->
      this.statusWaiting = true

  }

###########################################################
############ Survey Dispositions Control ##################

  $scope.surveyDispositionsControl = {

    selectedDisposition: null

    selectedEmployee: null

    selectedDepartment: null

    selectedAppointmentDate: null

    selectedAppointmentTime: null

    selectedCallbackDate: null

    selectedCallbackTime: null

    selectedCallbackNotes: null

    resetDispositionsForSurveyAttemptCreate: ->
      if this.selectedDisposition.appointment == true
        this.selectedEmployee = null
        this.selectedDepartment = null
        this.selectedCallbackDate = null
        this.selectedCallbackTime = null
        this.selectedCallbackNotes = null
      else if this.selectedDisposition.callback == true
        this.selectedEmployee = null
        this.selectedDepartment = null
        this.selectedAppointmentDate = null
        this.selectedAppointmentTime = null
      else if this.selectedDisposition.disposition_name == 'Transferred to Department'
        this.selectedEmployee = null
        this.selectedCallbackDate = null
        this.selectedCallbackTime = null
        this.selectedCallbackNotes = null
        this.selectedAppointmentDate = null
        this.selectedAppointmentTime = null
      else if this.selectedDisposition.disposition_name == 'Transferred to Employee'
        this.selectedDepartment = null
        this.selectedCallbackDate = null
        this.selectedCallbackTime = null
        this.selectedCallbackNotes = null
        this.selectedAppointmentDate = null
        this.selectedAppointmentTime = null

      return null

    resetDispositionsToDefault: ->
      this.selectedDisposition = null
      this.selectedEmployee = null
      this.selectedDepartment = null
      this.selectedAppointmentDate = null
      this.selectedAppointmentTime = null
      this.selectedCallbackDate = null
      this.selectedCallbackTime = null
      this.selectedCallbackNotes = null

    updateSelectedDispositionFromModal: (disposition) ->
      if disposition
        this.selectedDisposition = disposition

  }

###########################################################
############ Survey Questions Control #####################

  $scope.surveyQuestionsControl = {

    surveyAnswers: []

    survey_notes: null

    checkRequiredForQuestionResponses: ->
      required_still = false

      counter = 0

      _(this.surveyAnswers.length).times ->
        if $scope.surveyQuestionsControl.surveyAnswers[counter].required == true && $scope.surveyQuestionsControl.surveyAnswers[counter].survey_answer == '' && $scope.surveyQuestionsControl.surveyAnswers[counter].question_type != 'script'
          required_still = true

        counter += 1

      return required_still

    createSurveyAnswers: ->
      counter = 0

      _($scope.newSurvey.questions.length).times ->

        surveyAnswer = initializeNewSurveyAnswer()

        surveyAnswer.survey_template_question_id = $scope.newSurvey.questions[counter].question_id

        surveyAnswer.question_type = $scope.newSurvey.questions[counter].question_type

        if $scope.newSurvey.questions[counter].required == true

          surveyAnswer.required = true

        $scope.surveyQuestionsControl.surveyAnswers.push(surveyAnswer)

        counter += 1;

    displayRequiredErrorMessage: ->
      $('#required_questions_remain').show()

      index = 0
      _($scope.surveyQuestionsControl.surveyAnswers.length).times ->
        if $scope.surveyQuestionsControl.surveyAnswers[index].required == true && $scope.surveyQuestionsControl.surveyAnswers[index].survey_answer == '' && $scope.surveyQuestionsControl.surveyAnswers[index].question_type != 'script'
          $('.survey_template_questions .question .data')[index].style["background-color"] = '#fe9b91'
          $('.survey_template_questions .question .data')[index].style["color"] = '#0000FF'
          $('.survey_template_questions .question .data')[index].style["border"] = '1px solid #fe402b'

        index += 1

      return null

    formatSurveyAnswers: ->
      survey_answers = {}

      if $scope.surveyQuestionsControl.surveyAnswers && $scope.surveyQuestionsControl.surveyAnswers.length > 0

        index = 0

        _($scope.surveyQuestionsControl.surveyAnswers.length).times ->

          survey_answers[index] = $scope.surveyQuestionsControl.surveyAnswers[index]

          index += 1

      return survey_answers

    resetNew: ->
      this.surveyAnswers = []

      this.survey_notes = null

    updateSurveyAnswer: (question) ->
      if question && question.order > 0 && $scope.surveyQuestionsControl.surveyAnswers[question.order - 1]

        if typeof(question.answer) == "object"
          $scope.surveyQuestionsControl.surveyAnswers[question.order - 1].survey_answer = question.answer.option

        else
          $scope.surveyQuestionsControl.surveyAnswers[question.order - 1].survey_answer = question.answer

        # No more unanswered required questions
        if $scope.surveyQuestionsControl.checkRequiredForQuestionResponses() == false
          $('#required_questions_remain').hide()

        $('.survey_template_questions .question .data')[question.order - 1].style["background-color"] = '#f9f9f9'
        $('.survey_template_questions .question .data')[question.order - 1].style["color"] = 'inherit'
        $('.survey_template_questions .question .data')[question.order - 1].style["border-color"] = '#eee'

        return null

  }

###########################################################
################# Twilio Device Control ###################

  $scope.twilioDevice = {

    bridgeCalls: false

    callId: null

    callOnHold: false

    callOnHoldId: null

    callStatus: null
    
    connection: null

    connection_outgoing: null

    direction: null

    holdBackEnd: false

    isMuted: false

    onPhoneCall: false

    to_number: null

    transferNumber: null

    transferType: null
    
    userToken: null

    answerImcomingCall: ->
      this.callId = $('#incoming_call_id')[0].value
      $scope.incomingCustomersModalControl.pusher_call_id = $('#incoming_pusher_call_id')[0].value

      outgoing_params = { barge: false, listen: false, call_id: this.callId, accept_incoming: true}

      $scope.twilioDevice.connection_outgoing = Twilio.Device.connect(outgoing_params);

      $scope.twilioDevice.onPhoneCall = true

      NewSurveyService.acceptImcomingCall.query({ campaign_id: $('#incoming_campaign_id')[0].value, call_id: this.callId, customer_id: $('#incoming_customer_id')[0].value, pusher_call_id: $scope.incomingCustomersModalControl.pusher_call_id }, (responseData) ->
        if responseData.errors == false
          $scope.incomingCustomersModalControl.preMatchCustomers = responseData.pre_customers
          $scope.incomingCustomersModalControl.campaign_id = responseData.campaign_id
          $scope.customerSearchControl.dealer_id = responseData.dealer_id
          $('#open-incoming-customer-search').click()
      )

    cancelCall: ->
      if Twilio.Device
        Twilio.Device.disconnectAll();

        console.log("Disconnected from the call.")

    checkForHold: ->
      if this.onPhoneCall == false && this.callOnHold == false && this.holdBackEnd == false
        return 'no_active_call'

      else if this.onPhoneCall == true && this.callOnHold == false && this.holdBackEnd == false
        return 'active_call_no_hold'

      else if this.callOnHold == true && this.holdBackEnd == false
        return 'active_call_on_hold'

      else if this.holdBackEnd == true
        return 'in_back_end_for_twilio'

      else
        return null

    declineImcomingCall: ->
      console.log("hello world")

    dialCustomer: (to_number) ->

      this.direction = "outbound"

      if this.connection_outgoing != null
        this.connection_outgoing = null

      # Determine if it was a button that was clicked, get the number
      if to_number && !(parseInt(to_number, 10) > 0)
        to_number = $scope.newCustomer[to_number]

      if $scope.surveyDispositionsControl.selectedDisposition
        $scope.requestControl.saveAndNextSurvey = false
        $scope.requestControl.createSurveyAttempt()

      # After we have already checked for the to number
      if to_number && parseInt(to_number, 10) > 0
        gritterAdd("Now Dialing " + to_number)

        NewSurveyService.getCallId.query({ campaign_customer_id: $scope.newCustomer.campaign_customer_id, from_number: $scope.newSurvey.campaign_caller_id, to_number: to_number, called: $scope.newSurvey.agent_softphone, direction: this.direction }, (responseData) ->
          if responseData.errors == false && responseData.call_id && parseInt(responseData.call_id, 10) > 0
            $scope.twilioDevice.callId = responseData.call_id

            outgoing_params = { PhoneNumber: responseData.to_number, CallerId: responseData.caller_id, call_id: $scope.twilioDevice.callId }

            $scope.twilioDevice.connection_outgoing = Twilio.Device.connect(outgoing_params);

            $scope.twilioDevice.onPhoneCall = true
        )

    getChildCalls: ->
      if this.callId && parseInt(this.callId, 10) > 0
        NewSurveyService.getChildCalls.query({ call_id: this.callId }, (responseData) ->
          if responseData.errors == false
            console.log("Successfully got child calls.")
        )

    incomingCall: ->
      NewSurveyService.incomingCall.query({}, (responseData) ->
        if responseData.errors == false
          console.log("Successfully created imcomingCall AgentStatus")
      )

    initializeDevice: ->
      this.reInitializeNotSetUp()

      this.userToken = $scope.newSurvey.twilio_token

      if this.userToken != null
        this.device = Twilio.Device.setup(this.userToken, {debug: false});
        
        if this.connection_outgoing
          this.connection_outgoing = null

    mute: ->
      if this.callId && parseInt(this.callId, 10) > 0
        connection = Twilio.Device.activeConnection()

        if connection && connection.isMuted() == false

          connection.mute(true)

          $scope.twilioDevice.isMuted = true

      return null

    muteCheck: ->
      if this.callId != null && this.onPhoneCall == true && this.isMuted == false
        return 'active_call_no_mute'
      else if this.callId == null && this.onPhoneCall == false && this.isMuted == false
        return 'no_active_call'
      else if this.isMuted == true
        return 'active_call_on_mute'
      else
        return null

    outgoingCall: ->
      NewSurveyService.outgoingCall.query({ campaign_customer_id: $scope.newCustomer.campaign_customer_id }, (responseData) ->
        if responseData.errors == false
          console.log("Successfully created outgoingCall AgentStatus")
      )      

    placeCallOnHold: ->
      if this.callOnHold == false && this.callId && parseInt(this.callId, 10) > 0
        this.holdBackEnd = true
        this.callOnHoldId = this.callId

        NewSurveyService.callPark.query({ command: "holdCall", call_id: $scope.twilioDevice.callId }, (responseData) ->
          if responseData.errors == false
            $scope.twilioDevice.holdBackEnd = false
            $scope.twilioDevice.callOnHold = true

            $scope.twilioDevice.onPhoneCall = true

            gritterAdd("Call placed on hold successfully.");
        )

    reInitializeNotSetUp: ->
      this.bridgeCalls = false

      this.callId = null

      this.callOnHold = false

      this.callOnHoldId = null
    
      this.connection = null

      this.connection_outgoing = null

      this.holdBackEnd = false

      this.isMuted = false

      this.onPhoneCall = false

      this.to_number = null

      this.transferNumber = null

      this.transferType = null
    
      this.userToken = null

    resetTransferSettings: ->
      if $scope.twilioDevice
        this.transferNumber = null
        this.transferType = null
        this.bridgeCalls = false
        
        if $('#transfer_modal .close') && $('#transfer_modal .close').length > 0
          $('#transfer_modal .close').click()

      return null

    resumeCall: ->
      if this.callOnHold == true && this.callOnHoldId && parseInt(this.callOnHoldId, 10) > 0
        this.holdBackEnd = true

        NewSurveyService.callPark.query({ command: 'unHoldCall', call_id: this.callOnHoldId }, (responseData) ->
          if responseData.errors == false
            $scope.twilioDevice.holdBackEnd = false
            $scope.twilioDevice.callOnHold = false
            $scope.twilioDevice.callId = $scope.twilioDevice.callOnHoldId
            $scope.twilioDevice.callOnHoldId = null

            $scope.twilioDevice.onPhoneCall = true

            gritterAdd("Call resumed successfully. Call is live.")
        )

    resumeNoBridge: ->
      this.transferType = 'abortWarmTransfer'

      this.transferCall()

    sendDigits: ->
      if this.connection_outgoing

        phone_number = this.number.replace("(", "").replace(")", "").replace(" ", "").replace("-", "")
        
        index = 0

        _(phone_number.length).times ->

          $scope.twilioDevice.connection_outgoing.sendDigits(phone_number[index])

          index += 1

    setTransferType: (transferType) ->
      if transferType && transferType.length > 0
        this.transferType = transferType
      else
        this.transferType = null

    terminateCall: ->
      if this.callId && parseInt(this.callId, 10) > 0
        NewSurveyService.terminateCall.query({ call_id: this.callId }, (responseData) -> 
          if responseData.errors == false
            console.log("Ended call.")
        )

    transferCall: ->
      phoneNumberValidation = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im

      if this.transferNumber.match phoneNumberValidation
        NewSurveyService.callPark.query({ call_id: this.callId, command: this.transferType, transfer_number: this.transferNumber }, (responseData) ->
          if responseData.errors == false

            if $scope.twilioDevice.transferType == 'blindTransfer'
              $scope.twilioDevice.cancelCall()
              $scope.twilioDevice.resetTransferSettings()

              gritterAdd("Transferred the call successfully.")
            else if $scope.twilioDevice.transferType == 'warmTransfer'
              $scope.twilioDevice.bridgeCalls = true
              $scope.twilioDevice.transferType = 'warmConnect'

              gritterAdd("Please bridge the call when you are ready.")

            else if $scope.twilioDevice.transferType == 'abortWarmTransfer'
              $scope.twilioDevice.resetTransferSettings()

              gritterAdd("Connecting back to the customer...")
            else
              $scope.twilioDevice.resetTransferSettings()
        )
      else
        gritterAdd("Please enter a valid phone number.")

      return null

    transferCheck: ->
      if this.onPhoneCall == true && this.callId != null
        return 'active_call'
      else
        return 'no_active_call'

    unMute: ->
      if this.callId && parseInt(this.callId, 10) > 0
        connection = Twilio.Device.activeConnection()

        if connection && connection.isMuted() == true

          connection.mute(false)

          $scope.twilioDevice.isMuted = false

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

      $('#phone_offline').hide()
      $('#agent_on_call').hide()
      $('#disconnect_call').hide()
      $('#phone_ready').show()

    Twilio.Device.connect (connection) ->
      console.log("inside the connect handler")

      $('#phone_ready').hide()
      $('#phone_offline').hide()
      $('#agent_on_call').show()
      $('#disconnect_call').show()

      if $scope.twilioDevice && $scope.twilioDevice.direction && $scope.twilioDevice.direction == "incoming"
        $scope.twilioDevice.incomingCall()

      else
        $scope.twilioDevice.outgoingCall()

    Twilio.Device.incoming (connection) ->
      console.log("inside the incoming handler")
      connection.accept()

      $scope.twilioDevice.onPhoneCall = true
      $scope.twilioDevice.direction = "incoming"

    Twilio.Device.disconnect (connection) ->
      console.log("inside the disconnect handler")

      $scope.twilioDevice.terminateCall()
      $scope.agentStatusControl.wrapUpAgent()

      $('#agent_on_call').hide()
      $('#phone_offline').hide()
      $('#disconnect_call').hide()
      $('#phone_ready').show()

      $scope.twilioDevice.onPhoneCall = false

      $scope.twilioDevice.isMuted = false
      $scope.twilioDevice.connection_outgoing = null
      $scope.twilioDevice.direction = null
      # $scope.twilioDevice.callId = null

      if $('#transfer_modal') && $('#transfer_modal').hasClass('in')
        $('#transfer_modal .close').click()

    Twilio.Device.presence (presenceEvent) ->
      console.log("presenceEvent available = " + presenceEvent.available)

]
