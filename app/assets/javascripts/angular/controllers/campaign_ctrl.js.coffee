surveyApp.controller 'CampaignWizardCtrl', ['$scope', '$http', 'CampaignWizardService', '$location', '$pusher', ($scope, $http, CampaignWizardService, $location, $pusher) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    initalizeCampaign()
    initalizeDealerId()

    if $scope.generalControl.isCampaignPresent()
      $scope.campaignProgressControl.checkIfRequirementsCompleted()

    $scope.requestControl.setUpGeneral()

################################################################
############## Other Initializers ##############################

  findQuestionTypeIndex = (questionTypeId) ->
    next_index = 0
    desired_index = (-1)
    _($scope.stage1Control.questionTypes.length).times ->
      if $scope.stage1Control.questionTypes[next_index].id == questionTypeId
        desired_index = next_index

      next_index += 1

    return desired_index    

  findSurveyTemplateIndex = (surveyTemplateId) ->
    next_index = 0
    desired_index = (-1)
    _($scope.surveyTemplateControl.surveyTemplates.length).times ->
      if $scope.surveyTemplateControl.surveyTemplates[next_index].id == surveyTemplateId
        desired_index = next_index

      next_index += 1

    return desired_index

  findTwilioNumberIndex = (twilioNumberId) ->
    next_index = 0
    desired_index = (-1)
    _($scope.twilioNumberControl.twilioNumbers.length).times ->
      if $scope.twilioNumberControl.twilioNumbers[next_index].id == twilioNumberId
        desired_index = next_index

      next_index += 1

    return desired_index    

  initalizeCampaign = ->
    if $('#campaign_id') && $('#campaign_id').length > 0 && $('#campaign_id')[0].value && parseInt($('#campaign_id')[0].value, 10) > 0
      $scope.generalControl.campaign.id = $('#campaign_id')[0].value

  initalizeDealerId = ->
    if $('#dealer_id') && $('#dealer_id').length > 0 && $('#dealer_id')[0].value && parseInt($('#dealer_id')[0].value, 10) > 0
      $scope.generalControl.dealer_id = $('#dealer_id')[0].value

  setCurrentSurveyTemplate = (surveyTemplateId) ->
    desired_index = findSurveyTemplateIndex(surveyTemplateId)

    if desired_index >= 0
      return $scope.surveyTemplateControl.surveyTemplates[desired_index]
    else
      return null

  setCurrentTwilioNumber = (twilioNumberId) ->
    desired_index = findTwilioNumberIndex(twilioNumberId)

    if desired_index >= 0 && $scope.twilioNumberControl.twilioNumbers && $scope.twilioNumberControl.twilioNumbers.length > 0
      return $scope.twilioNumberControl.twilioNumbers[desired_index]
    else
      return null

################################################################
################################################################
################################################################
################################################################
################################################################
################################################################

################################################################
####################### Alerts Control #########################

  $scope.alertsControl = {

    activeUsers: []

    contactNotifications: false

    dealerDepartments: []

    displayInstruction: true

    dmsKey: null

    employeeAlerts: []

    errorMessage: null

    isCreating: false

    jobTitles: []

    selectedDepartment: null

    selectedEmployee: null

    selectedJobTitle: null

    selectedUser: null

    createDealerEmployee: ->
      if $scope.generalControl.campaign && $scope.generalControl.campaign.id
        CampaignWizardService.createDealerEmployee.query({ campaign_id: $scope.generalControl.campaign.id, user_id: this.selectedUser.id, job_title_id: this.getSelectedJobTitleId(), department_id: this.getSelectedDepartmentId(), dms_key: this.dmsKey, contact_notifications: this.contactNotifications }, (responseData) ->
          if responseData.errors == false
            $scope.alertsControl.employeeAlerts = responseData.alerts

            if $('#create_employee_modal .close') && $('#create_employee_modal .close').length > 0
              $('#create_employee_modal .close').click()
        )

    destroyDealerEmployee: (employee) ->
      if $scope.generalControl.campaign && $scope.generalControl.campaign.id && employee && employee.employee_id && parseInt(employee.employee_id, 10) > 0
        CampaignWizardService.destroyDealerEmployee.query({ campaign_id: $scope.generalControl.campaign.id, employee_id: employee.employee_id }, (responseData)->
          if responseData.errors == false
            $scope.alertsControl.employeeAlerts = responseData.alerts
        )

    getCampaignEmployeeAlerts: ->
      if $scope.generalControl.campaign && $scope.generalControl.campaign.id
        CampaignWizardService.getCampaignEmployeeAlerts.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.alertsControl.employeeAlerts = responseData.alerts
        )

    getSelectedDepartmentId: ->
      if this.selectedDepartment && parseInt(this.selectedDepartment.id, 10) > 0
        return this.selectedDepartment.id
      else
        return null

    getSelectedJobTitleId: ->
      if this.selectedJobTitle && parseInt(this.selectedJobTitle.id, 10) > 0
        return this.selectedJobTitle.id
      else
        return null

    updateCampaignSurveyAlert: (surveyAlert) ->
      if $scope.generalControl.isCampaignPresent() && surveyAlert && surveyAlert.id
        surveyAlertParams = {send_email: surveyAlert.send_email, send_text: surveyAlert.send_text}

        CampaignWizardService.updateCampaignSurveyAlert.query({ campaign_id: $scope.generalControl.campaign.id, campaign_survey_alert_id: surveyAlert.id, campaign_survey_alert_params: surveyAlertParams }, (responseData) ->
          if responseData.errors == false
            $scope.alertsControl.employeeAlerts = responseData.alerts
        )

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    setSelectedEmployee: (employee) ->
      if employee
        this.selectedEmployee = employee

      return null

    setUpCreateEmployeeModal: ->
      if $scope.generalControl.campaign && $scope.generalControl.campaign.id
        this.isCreating = true

        CampaignWizardService.getDealerEmployeeCreationInformation.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.alertsControl.activeUsers = responseData.all_users
            $scope.alertsControl.dealerDepartments = responseData.departments
            $scope.alertsControl.jobTitles = responseData.job_titles

            $scope.alertsControl.isCreating = false
        )

    skipStep: ->
      if $('#query-params-link') && $('#query-params-link').length > 0
        $scope.tabViewControl.changeView('query_params')

      return null

    updateAndNextStep: ->
      if $('#query-params-link') && $('#query-params-link').length > 0
        $scope.tabViewControl.changeView('query_params')

      return null

    verifyProperEmployee: ->
      if !this.selectedUser
        this.errorMessage = "Please select a user."

      else
        this.errorMessage = null

        this.createDealerEmployee()
    
  }

################################################################
####################### Attempts Control #######################

  $scope.attemptsControl = {

    displayInstruction: true

    voicemailAttempts: []

    getCampaignAttempts: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getCampaignAttempts.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.attemptsControl.voicemailAttempts = responseData.attempts
        )

    initializeNewVoicemailAttempt: ->
      voicemailAttempt = {

        attempt_number: if this.voicemailAttempts && this.voicemailAttempts.length > 0 then (this.voicemailAttempts.length + 1) else 1

        campaign_id: if $scope.generalControl.campaign && $scope.generalControl.campaign.id then $scope.generalControl.campaign.id else null

        voicemail_message: null

      }

      return voicemailAttempt

    newVoicemailAttempt: ->
      this.voicemailAttempts.push(this.initializeNewVoicemailAttempt())

    removeAttempt: (attempt) ->
      if attempt && this.voicemailAttempts.indexOf(attempt) != (-1)
        index = this.voicemailAttempts.indexOf(attempt)
        this.voicemailAttempts.splice(index, 1)

        this.reorderAttempt()

    reorderAttempt: ->
      if this.voicemailAttempts && this.voicemailAttempts.length > 0
        newIndex = 0

        _(this.voicemailAttempts.length).times ->
          $scope.attemptsControl.voicemailAttempts[newIndex].attempt_number = newIndex + 1

          newIndex += 1

      return null

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    upVoicemailAttempt: (message) ->
      # debugger
      # if this.voicemailMessages && this.voicemailMessages.length > 1 && this.message.attempt_number > 1
      #   clickMessageNewIndex = message.attempt_number - 1

      #   this
      return null

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent() && this.voicemailAttempts && this.voicemailAttempts.length > 0
        voicemailAttempts = {attempts: this.voicemailAttempts}

        CampaignWizardService.updateAttempts.query({ campaign_id: $scope.generalControl.campaign.id, attempts: voicemailAttempts }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign

            $scope.tabViewControl.changeView('dispositions')
        )
      else if $scope.generalControl.isCampaignPresent()
        $scope.tabViewControl.changeView('dispositions')
    
  }

################################################################
################# Call Queues Control ##########################

  $scope.callQueuesControl = {

    callQueues: []

    displayInstruction: true

    errorMessage: null

    isCreating: false

    languages: []

    newCallQueue: {

      call_queue_name: null

      language_id: null

    }

    createCallQueue: ->
      if $scope.generalControl.isCampaignPresent() && this.newCallQueue
        this.isCreating = true
        
        CampaignWizardService.createCallQueue.query({ campaign_id: $scope.generalControl.campaign.id, call_queue_params: this.newCallQueue }, (responseData) ->
          if responseData.errors == false
            $scope.callQueuesControl.callQueues = responseData.call_queues

            $scope.campaignProgressControl.performCallQueuesCheck()

            $scope.campaignProgressControl.afterSaveActiveCheck()

            CampaignWizardService.canMakeActive.query({ campaign_id: $scope.generalControl.campaign.id }, (data) ->
              if data.errors == false && data.can_make_active == true && $('#make_active_and_exit') && $('#make_active_and_exit').length > 0 && (data.campaign.is_active == false || data.campaign.is_active == null)
                $('#make_active_and_exit').click()
            )
          else
            $scope.callQueuesControl.errorMessage = "That call queue name has already been taken. Please enter a different name."

          $scope.callQueuesControl.isCreating = false

          if $('#create_call_queue .close') && $('#create_call_queue .close').length > 0 && responseData.errors == false
            $('#create_call_queue .close').click()
        )

    destroyCallQueue: (call_queue_id) ->
      if $scope.generalControl.isCampaignPresent() && call_queue_id && parseInt(call_queue_id, 10) > 0
        CampaignWizardService.destroyCallQueue.query({ campaign_id: $scope.generalControl.campaign.id, call_queue_id: call_queue_id }, (responseData) ->
          if responseData.errors == false
            $scope.callQueuesControl.callQueues = responseData.call_queues
        )


    paramsVerify: ->
      if !this.newCallQueue.call_queue_name || this.newCallQueue.call_queue_name == ''
        this.errorMessage = "Please enter a call queue name"

      else if !this.newCallQueue.language_id
        this.errorMessage = "Please select a language."

      else
        this.errorMessage = null

        this.createCallQueue()

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    setUpCallQueues: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.setUpCallQueues.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false

            if responseData.call_queues && responseData.call_queues.length > 0
              $scope.callQueuesControl.callQueues = responseData.call_queues

            $scope.callQueuesControl.languages = responseData.languages
            $scope.callQueuesControl.newCallQueue.call_queue_name = $scope.generalControl.campaign.campaign_name
            $scope.callQueuesControl.currentTwilioNumber = responseData.twilio_number

          else
            gritterAdd("You must have selected a twilio number in the previous tab before creating call queues.")
            $scope.tabViewControl.changeView("twilio_number")
        )
      else
        gritterAdd("Error.")

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent()
        $scope.campaignProgressControl.requirements.call_queues = true
        $scope.campaignProgressControl.performCallQueuesCheck()

        $scope.tabViewControl.changeView('attempts')


  }

###########################################################
################# Campaign Progress #######################

  $scope.campaignProgressControl = {

    isReady: false

    requirements: {

      campaign_name: false

      campaign_name_class: 'badge-danger'

      survey_template: false

      survey_template_class: 'badge-danger'

      twilio_number: false

      twilio_number_class: 'badge-danger'

      call_queues: false

      call_queues_class: 'badge-danger'

      dispositions: false

      dispositions_class: 'badge-danger'

      max_attempts: false

      customer_expiration_days: false

      settings_class: 'badge-danger'

      is_active: false

    }

    status: null

    afterSaveActiveCheck: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.canMakeActive.query({ campaign_id: $scope.generalControl.campaign.id }, (data) ->
          if data.errors == false && data.can_make_active == true && $('#make_active_and_exit') && $('#make_active_and_exit').length > 0 && (data.campaign.is_active == false || data.campaign.is_active == null)
            $('#make_active_and_exit').click()
        )

    afterUpdateIsActive: ->
      if $scope.generalControl.isCampaignPresent()
        if this.params.is_active == true && $('#prompt_is_active_true') && $('#prompt_is_active_true').length > 0
          $('#prompt_is_active_true').click()
        else if this.params.is_active == false && $('#prompt_is_active_false') && $('#prompt_is_active_false').length > 0
          $('#prompt_is_active_false').click()

      return null

    checkIfRequirementsCompleted: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.checkIfRequirementsCompleted.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.campaignProgressControl.requirements = responseData.requirements
            $scope.generalControl.campaign = responseData.campaign

            $scope.campaignProgressControl.performCampaignNameCheck()
            $scope.campaignProgressControl.performSurveyTemplateCheck()
            $scope.campaignProgressControl.performTwilioNumberCheck()
            $scope.campaignProgressControl.performCallQueuesCheck()
            $scope.campaignProgressControl.performDispositionsCheck()
            $scope.campaignProgressControl.performSettingsCheck()

            $scope.campaignProgressControl.ableActive = responseData.can_make_active.can_make_active
            $scope.campaignProgressControl.params.is_active = responseData.campaign.is_active
        )
      else
        gritterAdd("You must create the campaign first before moving on from the general step.")
        $scope.tabViewControl.changeView('general')

    makeActiveAndExit: ->
      if $scope.generalControl.isCampaignPresent()
        campaign_params = {is_active: true}

        CampaignWizardService.updateCampaign.query({ campaign_id: $scope.generalControl.campaign.id, campaign_params: campaign_params }, (responseData) ->
          if responseData.errors == false
            window.location = '/dealers/' + responseData.campaign.dealer_id + '/campaigns'
        )

    makeInactiveAndExit: ->
      if $scope.generalControl.isCampaignPresent()
        campaign_params = {is_active: false}

        CampaignWizardService.updateCampaign.query({ campaign_id: $scope.generalControl.campaign.id, campaign_params: campaign_params }, (responseData) ->
          if responseData.errors == false
            window.location = '/dealers/' + responseData.campaign.dealer_id + '/campaigns'
        )

    performCampaignNameCheck: ->
      if $scope.campaignProgressControl.requirements.campaign_name && $scope.campaignProgressControl.requirements.campaign_name == true
        this.requirements.campaign_name_class = 'badge-success'
      else
        this.requirements.campaign_name_class = 'badge-danger'

    performSurveyTemplateCheck: ->
      if $scope.campaignProgressControl.requirements.survey_template && $scope.campaignProgressControl.requirements.survey_template == true
        this.requirements.survey_template_class = 'badge-success'
      else
        this.requirements.survey_template_class = 'badge-danger'

    performTwilioNumberCheck: ->
      if $scope.campaignProgressControl.requirements.twilio_number && $scope.campaignProgressControl.requirements.twilio_number == true
        this.requirements.twilio_number_class = 'badge-success'
      else
        this.requirements.twilio_number_class = 'badge-danger'

    performCallQueuesCheck: ->
      if $scope.campaignProgressControl.requirements.call_queues && $scope.campaignProgressControl.requirements.call_queues == true
        this.requirements.call_queues_class = 'badge-success'
      else
        this.requirements.call_queues_class = 'badge-danger'

    performDispositionsCheck: ->
      if $scope.campaignProgressControl.requirements.dispositions && $scope.campaignProgressControl.requirements.dispositions == true
        this.requirements.dispositions_class = 'badge-success'
      else
        this.requirements.dispositions_class = 'badge-danger'

    performSettingsCheck: ->
      if $scope.campaignProgressControl.requirements.max_attempts && $scope.campaignProgressControl.requirements.max_attempts == true && $scope.campaignProgressControl.requirements.customer_expiration_days && $scope.campaignProgressControl.requirements.customer_expiration_days == true
        this.requirements.settings_class = 'badge-success'
      else
        this.requirements.settings_class = 'badge-danger'

    setStatus: ->
      if this.validCampaignName && this.validDispositions && this.validTwilioNumber && this.validCallQueues && this.validSurveyTemplate && this.validSurveyTemplateQuestion && this.validMaxAttempts && this.validCustomerExpirationDays && $scope.generalControl.campaign && $scope.generalControl.campaign.is_active == false
        this.status = 'All of the requirements are set. Edit to active whenever you are ready to begin your campaign.'
        this.isReady = true
      else if $scope.generalControl.campaign && $scope.generalControl.campaign.is_active
        this.isReady = true
        this.status = 'Active'
      else
        this.status = 'Inactive'
        this.isReady = false

    ableActive: false

    isChecking: false

    params: {

      is_active: false

    }

    canMakeActive: ->
      if $scope.generalControl.isCampaignPresent()
        this.isChecking = true

        CampaignWizardService.canMakeActive.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.runCampaignControl.params.is_active = responseData.campaign.is_active

            $scope.runCampaignControl.ableActive = responseData.can_make_active

          $scope.runCampaignControl.isChecking = false
        )
      else
        gritterAdd("You must complete all of the steps shown in the campaign progress tab before you can make this campaign active and run it.")
        $scope.tabViewControl.changeView('general')

    updateIsActive: (boolean) ->
      this.params.is_active = boolean

      this.afterUpdateIsActive()

    updateIsActiveFalse: ->
      this.params.is_active = false

    updateIsActiveTrue: ->
      this.params.is_active = true

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
      $scope.generalControl.watchCampaignChanges.end_date = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.generalControl.watchCampaignChanges.end_date == null
        this.today()

      $scope.endDatepicker.opened = true;

    today: ->
      $scope.generalControl.watchCampaignChanges.end_date = new Date();

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
      $scope.generalControl.watchCampaignChanges.start_date = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.generalControl.watchCampaignChanges.start_date == null
        this.today()

      $scope.startDatepicker.opened = true;

    today: ->
      $scope.generalControl.watchCampaignChanges.start_date = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

################################################################
################# Dispositions Control #########################

  $scope.dispositionsControl = {

    displayInstruction: true

    enteredPrice: null

    excludedDispositions: []

    includedDispositions: []

    makeDefaultPrice: false

    newDisposition: {

      denotes_appointment: false
      
      denotes_callback: false
      
      denotes_contact: false
      
      disposition_description: null
      
      is_complete: false
      
      is_default: false
      
      price: null
      
      send_survey: false

      tooltip_text: null

    }

    selectedDisposition: null

    campaignDispositionUpdate: (action) ->
      if action && this.selectedDisposition && this.selectedDisposition.length > 0
        CampaignWizardService.campaignDispositionUpdate.query({ campaign_id: $scope.generalControl.campaign.id, disposition_id: this.selectedDisposition[0].disposition_id, price: this.enteredPrice, campaign_disposition_action: action, make_default_price: this.makeDefaultPrice }, (responseData) ->
          if responseData.errors == false
            $scope.dispositionsControl.excludedDispositions = responseData.excluded_dispositions
            $scope.dispositionsControl.includedDispositions = responseData.included_dispositions

          $scope.dispositionsControl.enteredPrice = null
          $scope.dispositionsControl.makeDefaultPrice = false
          $scope.dispositionsControl.selectedDisposition = null
        )

    campaignDispositionPriceUpdate: ->
      if this.selectedDisposition && this.selectedDisposition.length > 0 && this.enteredPrice
        CampaignWizardService.campaignDispositionPriceUpdate.query({ campaign_id: $scope.generalControl.campaign.id, disposition_id: this.selectedDisposition[0].disposition_id, price: this.enteredPrice, make_default_price: this.makeDefaultPrice }, (responseData) ->
          if responseData.errors == false
            $scope.dispositionsControl.includedDispositions = responseData.included_dispositions

          $scope.dispositionsControl.enteredPrice = null
          $scope.dispositionsControl.makeDefaultPrice = false
          $scope.dispositionsControl.selectedDisposition = null
        )

    checkProperMove: (action) ->
      if action == 'add' && this.selectedDisposition && this.includedDispositions.indexOf(this.selectedDisposition[0]) == (-1) && $('#dispo_btnSelectHidden') && $('#dispo_btnSelectHidden').length > 0
        $('#dispo_btnSelectHidden').click()

      if action == 'remove' && this.selectedDisposition && this.excludedDispositions.indexOf(this.selectedDisposition[0]) == (-1)
        this.campaignDispositionUpdate(action)

      return null

    checkProperUpdate: ->
      if this.selectedDisposition && this.includedDispositions.indexOf(this.selectedDisposition[0]) != (-1) && $('#dispo_priceUpdateHidden') && $('#dispo_priceUpdateHidden').length > 0
        $('#dispo_priceUpdateHidden').click()

      return null

    createNewDisposition: ->
      if this.newDisposition.disposition_description && this.newDisposition.disposition_description.length > 0
        CampaignWizardService.createNewDisposition.query({ campaign_id: $scope.generalControl.campaign.id, disposition_description: this.newDisposition.disposition_description, tooltip_text: this.newDisposition.tooltip_text, price: this.newDisposition.price, denotes_appointment: this.newDisposition.denotes_appointment, denotes_contact: this.newDisposition.denotes_contact, is_complete: this.newDisposition.is_complete, is_default: this.newDisposition.is_default, denotes_callback: this.newDisposition.denotes_callback, send_survey: this.newDisposition.send_survey, is_active: this.newDisposition.is_active }, (responseData) ->
          if responseData.errors == false
            $scope.dispositionsControl.includedDispositions = responseData.included_dispositions
            $scope.dispositionsControl.initializeNewDisposition()

            gritterAdd("Successfully created new disposition.")
        )

    displayDispositionWithPrice: (disposition) ->
      if disposition && disposition.disposition_price
        return disposition.disposition_description + ' (' + disposition.disposition_price.toFixed(2) + ')'
      else
        return disposition.disposition_description + ' (0.00)'

    getDispositions: ->
      CampaignWizardService.getDispositions.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
        if responseData.errors == false
          $scope.dispositionsControl.excludedDispositions = responseData.excluded_dispositions
          $scope.dispositionsControl.includedDispositions = responseData.included_dispositions
      )

    initializeNewDisposition: ->
      this.newDisposition = {

        denotes_appointment: false
        
        denotes_callback: false
        
        denotes_contact: false
        
        disposition_description: null
        
        is_complete: false
        
        is_default: false
        
        price: null
        
        send_survey: false

        tooltip_text: null

      }

    resetDispositions: ->
      if $scope.generalControl.campaign && $scope.generalControl.campaign.id
        CampaignWizardService.resetDispositions.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.dispositionsControl.excludedDispositions = responseData.excluded_dispositions
            $scope.dispositionsControl.includedDispositions = responseData.included_dispositions
            $scope.dispositionsControl.selectedDisposition = null
            $scope.dispositionsControl.enteredPrice = null
            $scope.dispositionsControl.makeDefaultPrice = false
        )

    skipStep: ->
      if $('#alert-link') && $('#alert-link').length > 0
        $scope.tabViewControl.changeView('alerts')

      return null

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    updateAndNextStep: ->
      if $('#alert-link') && $('#alert-link').length > 0
        $scope.campaignProgressControl.requirements.dispositions = true
        $scope.campaignProgressControl.performDispositionsCheck()
        $scope.campaignProgressControl.afterSaveActiveCheck()

        $scope.tabViewControl.changeView('alerts')

      return null

  }

################################################################
################# General Control ##############################

  $scope.generalControl = {

    campaign: {}

    dealer_id: null

    displayInstruction: true

    watchCampaignChanges: {}

    isChanges: ->
      if this.watchCampaignChanges.campaign_name != this.campaign.campaign_name || this.watchCampaignChanges.start_date != this.campaign.start_date || this.watchCampaignChanges.end_date != this.campaign.end_date then true else false

    isCampaignPresent: ->
      if this.campaign && this.campaign.id && parseInt(this.campaign.id, 10) > 0 then true else false

    getCampaignInformation: ->
      if this.campaign && this.campaign.id && parseInt(this.campaign.id, 10) > 0
        CampaignWizardService.getCampaignInformation.query({ campaign_id: this.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.generalControl.watchCampaignChanges.campaign_name = responseData.campaign.campaign_name
            $scope.generalControl.watchCampaignChanges.start_date = responseData.campaign.start_date
            $scope.generalControl.watchCampaignChanges.end_date = responseData.campaign.end_date
        )

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    updateAndNextStep: ->
      if this.campaign && this.campaign.id && parseInt(this.campaign.id, 10) > 0 && this.isChanges()
        CampaignWizardService.updateCampaign.query({ campaign_id: this.campaign.id, campaign_params: this.watchCampaignChanges }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.campaignProgressControl.requirements.campaign_name = true
            $scope.campaignProgressControl.performCampaignNameCheck()
            $scope.campaignProgressControl.afterSaveActiveCheck()

            $scope.tabViewControl.changeView('survey_template')
        )

      else if (this.campaign.id == undefined || this.campaign.id == null) && this.dealer_id && parseInt(this.dealer_id, 10) > 0 && this.isChanges() && this.watchCampaignChanges.campaign_name && this.watchCampaignChanges.campaign_name.length > 0
        this.watchCampaignChanges.dealer_id = this.dealer_id

        CampaignWizardService.createCampaign.query({ campaign_params: this.watchCampaignChanges }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.campaignProgressControl.requirements.campaign_name = true
            $scope.campaignProgressControl.performCampaignNameCheck()
            $scope.campaignProgressControl.afterSaveActiveCheck()

            # $location.url("/dealers/" + $scope.generalControl.campaign.dealer_id + "/campaigns/" + $scope.generalControl.campaign.id + "/edit")

            $scope.tabViewControl.changeView('survey_template')
        )

      else if this.campaign && this.campaign.id && parseInt(this.campaign.id, 10) > 0
        $scope.tabViewControl.changeView('survey_template')
      else
        gritterAdd("You must enter at least a campaign name before you can move on.")

  }

################################################################
####################### Query Params Control ###################

  $scope.queryParamsControl = {

    displayInstruction: true

    errorMessage: null

    hasGotCriterionDetails: false

    inProgressCriterion: null

    # Appointment Params

    missedAppointmentParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'missed_appointment'

      params: {

        days: null

        query: 'missed_appointment'

      }

      resetParams: ->
        this.id = null

        this.isIncluded = false

        this.params.days = null

    }

    previousAppointmentParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'previous_appointment'

      params: {

        days: null

        query: 'previous_appointment'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

    }

    upcomingAppointmentParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'upcoming_appointment'

      params: {

        days: null

        query: 'upcoming_appointment'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

    }

    # Email / Phone Params

    hasEmailParam: {

      checkRequirements: ->
        if this.params.query && this.params.query.length > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."
          
          return false

      hasEmailDropdown: [{text: 'have', query: 'email_not_null'}, {text: 'do not have', query: 'email_null'}]
      
      id: null

      isIncluded: false

      name: 'has_or_has_not_email'

      params: {

        query: null

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.query = null
    }

    hasPhoneNumberParam: {

      checkRequirements: ->
        if this.params.query && this.params.query.length > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."
          
          return false

      hasPhoneNumberDropdown: [{text: 'have', query: 'phone_not_null'}, {text: 'do not have', query: 'phone_null'}]
      
      id: null

      isIncluded: false

      name: 'has_or_has_not_phone'

      params: {

        query: null

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.query = null

    }

    # Postal Code Params

    inPostalCodeParam: {

      inPostalCode: false

      inPostalCodeDropdown: [{text: '33966', value: 'phone_not_null'}, {text: '50613', value: 'phone_null'}]

      name: 'in_postal_code'

      selectedPostalCodeParam: null

    }

    postalCodeLikeParam: {

      postalCodeLike: false

      postalCodeLikeDropdown: [{text: '33966', value: 'phone_not_null'}, {text: '50613', value: 'phone_null'}]

      name: 'postal_code_like'

      selectedPostalCodeLike: null

    }

    # Sales Params

    noSaleInDaysParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'no_sale_in_days'

      params: {

        days: null

        query: 'no_sales_in_days'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

    }

    salesEventParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0 && this.params.operand && this.params.operand.length > 0
          return true
        else if !this.params.operand || this.params.operand.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."

          return false
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'sales_event'

      operandDropdown: [{text: 'more than', operand: '<'}, {text: 'less than', operand: '>'}, {text: 'exactly', operand: '='}]

      params: {

        days: null

        operand: null

        query: 'sales_event'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false

        this.params.days = null
        
        this.params.operand = null

    }

    # Service Params

    noServiceInDaysParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0
          return true
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      name: 'no_service_in_days'

      isIncluded: false

      params: {

        days: null

        query: 'no_service_in_days'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

    }

    serviceEventParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0 && this.params.operand && this.params.operand.length > 0
          return true
        else if !this.params.operand || this.params.operand.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."

          return false
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'service_event'

      operandDropdown: [{text: 'more than', operand: '<'}, {text: 'less than', operand: '>'}, {text: 'exactly', operand: '='}]

      params: {

        days: null

        operand: null

        query: 'service_event'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

        this.params.operand = null

    }

    serviceLaborTypeParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0 && this.params.operand && this.params.operand.length > 0 && this.labor_type_ids && this.labor_type_ids.length > 0
          return true
        else if !this.params.operand || this.params.operand.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."

          return false
        else if !this.labor_type_ids || this.labor_type_ids.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected any labor types. Please select some."

          return false
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      laborTypes: []

      labor_type_ids: []

      name: 'service_labor_type'

      operandDropdown: [{text: 'more than', operand: '<'}, {text: 'less than', operand: '>'}, {text: 'exactly', operand: '='}]

      params: {

        days: null

        operand: null

        query: 'service_labor_type'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false

        this.labor_type_ids = null
        
        this.params.days = null

        this.params.operand = null

    }

    declinedServiceLaborParam: {

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0 && this.params.operand && this.params.operand.length > 0
          return true
        else if !this.params.operand || this.params.operand.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."

          return false
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'declined_service'

      operandDropdown: [{text: 'more than', operand: '<'}, {text: 'less than', operand: '>'}, {text: 'exactly', operand: '='}]

      params: {

        days: null

        operand: null

        query: 'declined_service'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

        this.params.operand = null

    }

    lastServiceBetweenParam: {

      checkRequirements: ->
        if this.params && this.params.between_higher && parseInt(this.params.between_higher, 10) > 0 && this.params.between_lower && parseInt(this.params.between_lower, 10) > 0
          return true
        else if !this.params.between_lower || this.params.between_lower.length == 0
          $scope.queryParamsControl.errorMessage = "The between lower value must be greater than 0."

          return false
        else
          $scope.queryParamsControl.errorMessage = "The between higher value must be greater than 0."

          return false

      id: null

      isIncluded: false

      name: 'last_service_between'

      params: {

        between_higher: null

        between_lower: null

        query: 'last_service_between'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.between_higher = null

        this.params.between_lower = null

    }

    serviceOperationCodeParam: {

      days: null

      name: 'service_operation_code'

      selectedServiceOperationCode: null

      serviceOperationCode: false

      serviceOperationCodes: []

      operandDropdown: [{text: 'more than', value: '<'}, {text: 'less than', value: '>'}, {text: 'exactly', value: '='}]

      selectedOperand: null

      checkRequirements: ->
        if this.params && this.params.days && parseInt(this.params.days, 10) > 0 && this.params.operand && this.params.operand.length > 0
          return true
        else if !this.params.operand || this.params.operand.length == 0
          $scope.queryParamsControl.errorMessage = "You have not selected an option for the query. Please select one."

          return false
        else
          $scope.queryParamsControl.errorMessage = "Days must be greater than 0!"

          return false

      id: null

      isIncluded: false

      name: 'service_operation_code'

      operandDropdown: [{text: 'more than', operand: '<'}, {text: 'less than', operand: '>'}, {text: 'exactly', operand: '='}]

      operationalCodes: []

      params: {

        days: null

        operand: null

        query: 'service_operation_code'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.days = null

        this.params.operand = null

        this.selectedOperationalCodes = null

      selectedOperationalCodes: null

    }

    # Vehicle Params

    estimatedMileageParam: {

      checkRequirements: ->
        if this.params && this.params.between_higher && parseInt(this.params.between_higher, 10) > 0 && this.params.between_lower && parseInt(this.params.between_lower, 10) > 0
          return true
        else if !this.params.between_lower || this.params.between_lower.length == 0
          $scope.queryParamsControl.errorMessage = "The between lower value must be greater than 0."

          return false
        else
          $scope.queryParamsControl.errorMessage = "The between higher value must be greater than 0."

          return false

      id: null

      isIncluded: false

      name: 'estimated_mileage'

      params: {

        between_higher: null

        between_lower: null

        query: 'estimated_mileage'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
        this.params.between_higher = null

        this.params.between_lower = null

    }

    vehicleYearMakeModelParam: {

      checkRequirements: ->
        if this.params && ((this.vehicle_year_ids && this.vehicle_year_ids.length > 0) || (this.vehicle_make_ids && this.vehicle_make_ids.length > 0) || (this.vehicle_model_ids && this.vehicle_model_ids.length > 0))
          return true
        else
          $scope.queryParamsControl.errorMessage = "You have not selected any options. Please select some."

          return false

      id: null

      isIncluded: false

      name: 'vehicle_year_make_model'

      params: {

        query: 'vehicle_year_make_model'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false

        this.vehicle_make_ids = []

        this.vehicle_model_ids = []

        this.vehicle_year_ids = []
        
      vehicleMakes: []

      vehicle_make_ids: []

      vehicleModels: []

      vehicle_model_ids: []

      vehicleYears: []

      vehicle_year_ids: []

    }

    serviceIntervalNow: {

      checkRequirements: ->
        return true

      id: null

      isIncluded: false

      name: 'service_interval_now_5000'

      params: {

        query: 'service_interval_now_5000'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
    
    }

    serviceIntervalOverdue: {

      checkRequirements: ->
        return true

      id: null

      isIncluded: false

      name: 'service_interval_overdue_5000'

      params: {

        query: 'service_interval_overdue_5000'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false
        
    }

    serviceIntervalSoon: {

      checkRequirements: ->
        return true

      id: null

      isIncluded: false

      name: 'service_interval_soon_5000'

      params: {

        query: 'service_interval_soon_5000'

      }

      resetParams: ->
        this.id = null
        
        this.isIncluded = false

    }

    createCampaignCriterion: (criterion) ->
      if criterion && this[criterion] && this[criterion].checkRequirements() && $scope.generalControl.isCampaignPresent()
        this.inProgressCriterion = criterion

        labor_type_ids = this.prepareLaborTypeIds(criterion)

        vehicleDetailParams = this.prepareVehicleYearMakeModelIds(criterion)

        CampaignWizardService.createCampaignCriterion.query({ campaign_id: $scope.generalControl.campaign.id, criterion_type_name: this[criterion].name, criterion_params: this[criterion].params, labor_type_ids: labor_type_ids, vehicle_detail_ids: vehicleDetailParams }, (responseData) ->
          if responseData.errors == false
            $scope.queryParamsControl[$scope.queryParamsControl.inProgressCriterion].isIncluded = true
            $scope.queryParamsControl[$scope.queryParamsControl.inProgressCriterion].id = responseData.criterion.id

            $scope.queryParamsControl.inProgressCriterion = null
            $scope.queryParamsControl.errorMessage = null
        )
      else
        gritterAdd(this.errorMessage)

        this.errorMessage = null

    findDropdownIndex: (dropdown, query) ->
      if query && query.length > 0
        next_index = 0
        desired_index = (-1)
        _(dropdown.length).times ->
          if dropdown[next_index].query == query
            desired_index = next_index

          next_index += 1

        return desired_index

    findDropdownIdIndex: (dropdown, id) ->
      if id && parseInt(id, 10) > 0
        next_index = 0
        desired_index = (-1)
        _(dropdown.length).times ->
          if dropdown[next_index].id == id
            desired_index = next_index

          next_index += 1

        return desired_index

    findDropdownIndexOperand: (dropdown, operand) ->
      if operand && operand.length > 0
        next_index = 0
        desired_index = (-1)
        _(dropdown.length).times ->
          if dropdown[next_index].operand == operand
            desired_index = next_index

          next_index += 1

        return desired_index

    disableCriterion: (criterion) ->
      if criterion && this[criterion] && this[criterion].id && parseInt(this[criterion].id, 10) > 0 && $scope.generalControl.isCampaignPresent()
        this.inProgressCriterion = criterion

        CampaignWizardService.disableCriterion.query({ criterion_id: this[criterion].id }, (responseData) ->
          if responseData.errors == false
            if $scope.queryParamsControl[$scope.queryParamsControl.inProgressCriterion]
              $scope.queryParamsControl[$scope.queryParamsControl.inProgressCriterion].resetParams()

            $scope.queryParamsControl.inProgressCriterion = null
        )


    getCampaignCriterions: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getCampaignCriterions.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.queryParamsControl.hasGotCriterionDetails = true
            $scope.queryParamsControl.serviceLaborTypeParam.laborTypes = responseData.labor_types
            $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleYears = responseData.vehicle_years
            $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleMakes = responseData.vehicle_makes
            $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleModels = responseData.vehicle_models

            # Appointment Params
            if responseData.missed_appointment && responseData.missed_appointment.id && parseInt(responseData.missed_appointment.id, 10) > 0
              $scope.queryParamsControl.missedAppointmentParam.params.days = responseData.missed_appointment.days
              $scope.queryParamsControl.missedAppointmentParam.id = responseData.missed_appointment.id
              $scope.queryParamsControl.missedAppointmentParam.isIncluded = true

            if responseData.previous_appointment && responseData.previous_appointment.id && parseInt(responseData.previous_appointment.id, 10) > 0
              $scope.queryParamsControl.previousAppointmentParam.params.days = responseData.previous_appointment.days
              $scope.queryParamsControl.previousAppointmentParam.id = responseData.previous_appointment.id
              $scope.queryParamsControl.previousAppointmentParam.isIncluded = true

            if responseData.upcoming_appointment && responseData.upcoming_appointment.id && parseInt(responseData.upcoming_appointment.id, 10) > 0
              $scope.queryParamsControl.upcomingAppointmentParam.params.days = responseData.upcoming_appointment.days
              $scope.queryParamsControl.upcomingAppointmentParam.id = responseData.upcoming_appointment.id
              $scope.queryParamsControl.upcomingAppointmentParam.isIncluded = true

            # Email / Phone Number Params
            if responseData.has_email && responseData.has_email.id && parseInt(responseData.has_email.id, 10) > 0
              desired_index = $scope.queryParamsControl.findDropdownIndex($scope.queryParamsControl.hasEmailParam.hasEmailDropdown, responseData.has_email.query)

              $scope.queryParamsControl.hasEmailParam.id = responseData.has_email.id
              $scope.queryParamsControl.hasEmailParam.isIncluded = true

              if $scope.queryParamsControl.hasEmailParam.hasEmailDropdown[desired_index]
                $scope.queryParamsControl.hasEmailParam.params.query = $scope.queryParamsControl.hasEmailParam.hasEmailDropdown[desired_index].query

            if responseData.has_phone_number && responseData.has_phone_number.id && parseInt(responseData.has_phone_number.id, 10) > 0
              desired_index = $scope.queryParamsControl.findDropdownIndex($scope.queryParamsControl.hasPhoneNumberParam.hasPhoneNumberDropdown, responseData.has_phone_number.query)

              $scope.queryParamsControl.hasPhoneNumberParam.id = responseData.has_phone_number.id
              $scope.queryParamsControl.hasPhoneNumberParam.isIncluded = true

              if $scope.queryParamsControl.hasPhoneNumberParam.hasPhoneNumberDropdown[desired_index]
                $scope.queryParamsControl.hasPhoneNumberParam.params.query = $scope.queryParamsControl.hasPhoneNumberParam.hasPhoneNumberDropdown[desired_index].query

            # Postal Code Params

            # Sales Params
            if responseData.no_sale_in_days && responseData.no_sale_in_days.id && parseInt(responseData.no_sale_in_days.id, 10) > 0
              $scope.queryParamsControl.noSaleInDaysParam.params.days = responseData.no_sale_in_days.days
              $scope.queryParamsControl.noSaleInDaysParam.id = responseData.no_sale_in_days.id
              $scope.queryParamsControl.noSaleInDaysParam.isIncluded = true

            if responseData.sales_event && responseData.sales_event.id && parseInt(responseData.sales_event.id, 10) > 0
              $scope.queryParamsControl.salesEventParam.params.days = responseData.sales_event.days
              $scope.queryParamsControl.salesEventParam.id = responseData.sales_event.id
              $scope.queryParamsControl.salesEventParam.isIncluded = true
              desired_index = $scope.queryParamsControl.findDropdownIndexOperand($scope.queryParamsControl.salesEventParam.operandDropdown, responseData.sales_event.operand)

              if $scope.queryParamsControl.salesEventParam.operandDropdown[desired_index]
                $scope.queryParamsControl.salesEventParam.params.operand = $scope.queryParamsControl.salesEventParam.operandDropdown[desired_index].operand

            # Services Params
            if responseData.no_service_in_days && responseData.no_service_in_days.id && parseInt(responseData.no_service_in_days.id, 10) > 0
              $scope.queryParamsControl.noServiceInDaysParam.params.days = responseData.no_service_in_days.days
              $scope.queryParamsControl.noServiceInDaysParam.id = responseData.no_service_in_days.id
              $scope.queryParamsControl.noServiceInDaysParam.isIncluded = true

            if responseData.service_event && responseData.service_event.id && parseInt(responseData.service_event.id, 10) > 0
              $scope.queryParamsControl.serviceEventParam.params.days = responseData.service_event.days
              $scope.queryParamsControl.serviceEventParam.id = responseData.service_event.id
              $scope.queryParamsControl.serviceEventParam.isIncluded = true
              desired_index = $scope.queryParamsControl.findDropdownIndexOperand($scope.queryParamsControl.serviceEventParam.operandDropdown, responseData.service_event.operand)

              if $scope.queryParamsControl.serviceEventParam.operandDropdown[desired_index]
                $scope.queryParamsControl.serviceEventParam.params.operand = $scope.queryParamsControl.serviceEventParam.operandDropdown[desired_index].operand

            if responseData.service_labor_type && responseData.service_labor_type.id && parseInt(responseData.service_labor_type.id, 10) > 0 && $scope.queryParamsControl.serviceLaborTypeParam.laborTypes && $scope.queryParamsControl.serviceLaborTypeParam.laborTypes.length > 0
              $scope.queryParamsControl.serviceLaborTypeParam.params.days = responseData.service_labor_type.days
              $scope.queryParamsControl.serviceLaborTypeParam.id = responseData.service_labor_type.id
              $scope.queryParamsControl.serviceLaborTypeParam.isIncluded = true
              desired_index = $scope.queryParamsControl.findDropdownIndexOperand($scope.queryParamsControl.serviceLaborTypeParam.operandDropdown, responseData.service_labor_type.operand)

              if $scope.queryParamsControl.serviceLaborTypeParam.operandDropdown[desired_index]
                $scope.queryParamsControl.serviceLaborTypeParam.params.operand = $scope.queryParamsControl.serviceLaborTypeParam.operandDropdown[desired_index].operand

              selected_labor_type_ids = responseData.service_labor_type.labor_types
              index = 0
              _(selected_labor_type_ids.length).times ->
                desired_index = $scope.queryParamsControl.findDropdownIdIndex($scope.queryParamsControl.serviceLaborTypeParam.laborTypes, selected_labor_type_ids[index])

                if $scope.queryParamsControl.serviceLaborTypeParam.laborTypes[desired_index]
                  $scope.queryParamsControl.serviceLaborTypeParam.labor_type_ids.push($scope.queryParamsControl.serviceLaborTypeParam.laborTypes[desired_index].id)

                index += 1

            if responseData.declined_service_labor && responseData.declined_service_labor.id && parseInt(responseData.declined_service_labor.id, 10) > 0
              $scope.queryParamsControl.declinedServiceLaborParam.params.days = responseData.declined_service_labor.days
              $scope.queryParamsControl.declinedServiceLaborParam.id = responseData.declined_service_labor.id
              $scope.queryParamsControl.declinedServiceLaborParam.isIncluded = true
              desired_index = $scope.queryParamsControl.findDropdownIndexOperand($scope.queryParamsControl.declinedServiceLaborParam.operandDropdown, responseData.declined_service_labor.operand)

              if $scope.queryParamsControl.declinedServiceLaborParam.operandDropdown[desired_index]
                $scope.queryParamsControl.declinedServiceLaborParam.params.operand = $scope.queryParamsControl.declinedServiceLaborParam.operandDropdown[desired_index].operand

            if responseData.last_service_between && responseData.last_service_between.id && parseInt(responseData.last_service_between.id, 10) > 0
              $scope.queryParamsControl.lastServiceBetweenParam.params.between_higher = responseData.last_service_between.between_higher
              $scope.queryParamsControl.lastServiceBetweenParam.params.between_lower = responseData.last_service_between.between_lower
              $scope.queryParamsControl.lastServiceBetweenParam.id = responseData.last_service_between.id
              $scope.queryParamsControl.lastServiceBetweenParam.isIncluded = true
            
            # Vehicle Params
            if responseData.estimated_mileage && responseData.estimated_mileage.id && parseInt(responseData.estimated_mileage.id, 10) > 0
              $scope.queryParamsControl.estimatedMileageParam.params.between_higher = responseData.estimated_mileage.between_higher
              $scope.queryParamsControl.estimatedMileageParam.params.between_lower = responseData.estimated_mileage.between_lower
              $scope.queryParamsControl.estimatedMileageParam.id = responseData.estimated_mileage.id
              $scope.queryParamsControl.estimatedMileageParam.isIncluded = true

            if responseData.vehicle_year_make_model && responseData.vehicle_year_make_model.id && parseInt(responseData.vehicle_year_make_model.id, 10) > 0
              $scope.queryParamsControl.vehicleYearMakeModelParam.id = responseData.vehicle_year_make_model.id
              $scope.queryParamsControl.vehicleYearMakeModelParam.isIncluded = true

              selected_vehicle_years_ids = responseData.vehicle_year_make_model.vehicle_years
              index = 0
              _(selected_vehicle_years_ids.length).times ->
                desired_index = $scope.queryParamsControl.findDropdownIdIndex($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleYears, selected_vehicle_years_ids[index])

                if $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleYears[desired_index]
                  $scope.queryParamsControl.vehicleYearMakeModelParam.vehicle_year_ids.push($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleYears[desired_index].id)

                index += 1

              selected_vehicle_makes_ids = responseData.vehicle_year_make_model.vehicle_makes
              index = 0
              _(selected_vehicle_makes_ids.length).times ->
                desired_index = $scope.queryParamsControl.findDropdownIdIndex($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleMakes, selected_vehicle_makes_ids[index])

                if $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleMakes[desired_index]
                  $scope.queryParamsControl.vehicleYearMakeModelParam.vehicle_make_ids.push($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleMakes[desired_index].id)

                index += 1

              selected_vehicle_models_ids = responseData.vehicle_year_make_model.vehicle_models
              index = 0
              _(selected_vehicle_models_ids.length).times ->
                desired_index = $scope.queryParamsControl.findDropdownIdIndex($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleModels, selected_vehicle_models_ids[index])

                if $scope.queryParamsControl.vehicleYearMakeModelParam.vehicleModels[desired_index]
                  $scope.queryParamsControl.vehicleYearMakeModelParam.vehicle_model_ids.push($scope.queryParamsControl.vehicleYearMakeModelParam.vehicleModels[desired_index].id)

                index += 1

            if responseData.service_interval_now_5000 && responseData.service_interval_now_5000.id && parseInt(responseData.service_interval_now_5000.id, 10) > 0
              $scope.queryParamsControl.serviceIntervalNow.id = responseData.service_interval_now_5000.id
              $scope.queryParamsControl.serviceIntervalNow.isIncluded = true

            if responseData.service_interval_overdue_5000 && responseData.service_interval_overdue_5000.id && parseInt(responseData.service_interval_overdue_5000.id, 10) > 0
              $scope.queryParamsControl.serviceIntervalOverdue.id = responseData.service_interval_overdue_5000.id
              $scope.queryParamsControl.serviceIntervalOverdue.isIncluded = true

            if responseData.service_interval_soon_5000 && responseData.service_interval_soon_5000.id && parseInt(responseData.service_interval_soon_5000.id, 10) > 0
              $scope.queryParamsControl.serviceIntervalSoon.id = responseData.service_interval_soon_5000.id
              $scope.queryParamsControl.serviceIntervalSoon.isIncluded = true

            # $scope.queryParamsControl.getOperationalCodes()
            # $scope.queryParamsControl.getDealerLaborTypes()
        )

    getDealerLaborTypes: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getDealerLaborTypes.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.queryParamsControl.serviceLaborTypeParam.laborTypes = responseData.labor_types
        )

    getOperationalCodes: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getOperationalCodes.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.queryParamsControl.serviceOperationCodeParam.serviceOperationCodes = responseData.operational_codes

        )

    prepareLaborTypeIds: (criterion) ->
      if this[criterion] && this[criterion].labor_type_ids && this[criterion].labor_type_ids.length > 0
        labor_type_ids = {ids: this[criterion].labor_type_ids}
      else
        labor_type_ids = null

      labor_type_ids

    prepareVehicleYearMakeModelIds: (criterion) ->
      if this[criterion] && ((this[criterion].vehicle_year_ids && this[criterion].vehicle_year_ids.length > 0) || (this[criterion].vehicle_make_ids && this[criterion].vehicle_make_ids.length > 0) || (this[criterion].vehicle_model_ids && this[criterion].vehicle_model_ids.length > 0))
        vehicleYearMakeModelIds = {year_ids: this[criterion].vehicle_year_ids, make_ids: this[criterion].vehicle_make_ids, model_ids: this[criterion].vehicle_model_ids}
      else
        vehicleYearMakeModelIds = null

      vehicleYearMakeModelIds

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent()
        $scope.tabViewControl.changeView('settings')

    updateCriterion: (criterion) ->
      if criterion && this[criterion] && this[criterion].id && parseInt(this[criterion].id, 10) > 0 && this[criterion].checkRequirements() && $scope.generalControl.isCampaignPresent()
        this.inProgressCriterion = criterion

        labor_type_ids = this.prepareLaborTypeIds(criterion)

        vehicleDetailParams = this.prepareVehicleYearMakeModelIds(criterion)

        CampaignWizardService.updateCriterion.query({ criterion_id: this[criterion].id, criterion_params: this[criterion].params, labor_type_ids: labor_type_ids, vehicle_detail_ids: vehicleDetailParams }, (responseData) ->
          if responseData.errors == false
            $scope.queryParamsControl.inProgressCriterion = null
            $scope.queryParamsControl.errorMessage = null

            gritterAdd("Successfully updated the param.")
        )
      else
        gritterAdd(this.errorMessage)

        this.errorMessage = null
    
  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    cancelUpdate: ->
      if $scope.campaign.dealer_id && parseInt($scope.campaign.dealer_id, 10) > 0
        window.location = '/dealers/' + $scope.campaign.dealer_id + '/campaigns'

    setUpGeneral: ->
      $scope.generalControl.getCampaignInformation()

    setUpStage1: ->
      $scope.stage1Control.getSurveyTemplates()

  }

################################################################
##################### Settings Control #########################

  $scope.settingsControl = {

    campaignGroups: []

    communicationTypes: []

    dataSources: [{text: 'DMS'}, {text: 'Uploaded'}]

    displayInstruction1: true

    displayInstruction2: true

    displayInstruction3: true

    expirationDays: [{value: 1}, {value: 2}, {value: 3}, {value: 4}, {value: 5}, {value: 6}, {value: 7}, {value: 8}, {value: 9}, {value: 10}]

    hasGotDetails: false

    params: {

      campaign_group_id: null

      communication_type_id: null

      customer_expiration_days: null

      data_source: null

      exclusion_exempt: false

      include_roi: false

      max_daily_customers: null

      marketing_exclusion_days: null

      max_attempts: null

      recurring_days: []

      recurring_type: null

      whisper_recording_id: null

    }

    recurringDaysOptions: [{day: 'Sunday'}, {day: 'Monday'}, {day: 'Tuesday'}, {day: 'Wednesday'}, {day: 'Thursday'}, {day: 'Friday'}, {day: 'Saturday'}]

    recurringTypes: [{type: 'Never - One Time', id: 0}, {type: 'Daily', id: 1}, {type: 'Weekly', id: 2}, {type: 'Monthly', id: 3}, {type: 'Quarterly', id: 4}, {type: 'Annually', id: 5}]

    whisperRecordings: []

    checkSettingsParams: ->
      if $scope.generalControl.campaign.customer_expiration_days && parseInt($scope.generalControl.campaign.customer_expiration_days, 10) > 0
        $scope.campaignProgressControl.requirements.customer_expiration_days = true

      if $scope.generalControl.campaign.max_attempts && parseInt($scope.generalControl.campaign.max_attempts, 10) > 0
        $scope.campaignProgressControl.requirements.max_attempts = true

      return null

    getSettingsDetails: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getSettingsDetails.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.settingsControl.campaignGroups = responseData.campaign_groups
            $scope.settingsControl.communicationTypes = responseData.communication_types
            $scope.settingsControl.whisperRecordings = responseData.whisper_recordings
            $scope.generalControl.campaign = responseData.campaign

            $scope.settingsControl.params.campaign_group_id = $scope.generalControl.campaign.campaign_group_id
            $scope.settingsControl.params.communication_id = $scope.generalControl.campaign.communication_id
            $scope.settingsControl.params.customer_expiration_days = $scope.generalControl.campaign.customer_expiration_days
            $scope.settingsControl.params.data_source = $scope.generalControl.campaign.data_source
            $scope.settingsControl.params.exclusion_exempt = $scope.generalControl.campaign.exclusion_exempt
            $scope.settingsControl.params.include_roi = $scope.generalControl.campaign.include_roi
            $scope.settingsControl.params.max_daily_customers = $scope.generalControl.campaign.max_daily_customers
            $scope.settingsControl.params.max_attempts = $scope.generalControl.campaign.max_attempts
            $scope.settingsControl.params.whisper_recording_id = $scope.generalControl.campaign.whisper_recording_id
            $scope.settingsControl.params.recurring_type = $scope.generalControl.campaign.recurring_type
            $scope.settingsControl.params.recurring_days = $scope.generalControl.campaign.recurring_days
        )

    setInstructionDisplay1: (boolean) ->
      this.displayInstruction1 = boolean

    setInstructionDisplay2: (boolean) ->
      this.displayInstruction2 = boolean

    setInstructionDisplay3: (boolean) ->
      this.displayInstruction3 = boolean

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent() && $scope.settingsControl.params
        CampaignWizardService.updateCampaign.query({ campaign_id: $scope.generalControl.campaign.id, campaign_params: $scope.settingsControl.params }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign

            $scope.settingsControl.checkSettingsParams()

            $scope.campaignProgressControl.performSettingsCheck()
            $scope.campaignProgressControl.afterSaveActiveCheck()
        )

      else if $scope.generalControl.isCampaignPresent()
        this.checkSettingsParams()

        $scope.campaignProgressControl.performSettingsCheck()
        $scope.campaignProgressControl.afterSaveActiveCheck()

      else
        gritterAdd("Something went wrong.")

    updateExclusionExempt: (boolean) ->
      this.params.exclusion_exempt = boolean

    updateIncludeRoi: (boolean) ->
      this.params.include_roi = boolean

  }

################################################################
################# Survey Template Control ######################

  $scope.newSurveyTemplate = {

    closingStatement: null

    errorMessage: null

    inUseCampaignTemplates: []

    is_active: true

    isEditingQuestion: false

    isEditingTemplate: false

    newQuestion: null

    openingStatement: null

    questionBank: {

      changeView: (view) ->
        if view
          this.selectedView = view

      checkIfActive: (tabPane) ->
        if tabPane == this.selectedView
          return 'active'
        else
          return null

      multipleChoice: []

      ratingNumber1_10: []

      ratingNumber1_5: []

      script: []

      selectedView: 'multiple_choice'

      textFeedback: []

      trueFalse: []

      yesNo: []

    }

    questionBeingEdited: null

    selectedView: 'survey_template_name'

    surveyQuestions: []

    surveyTemplateId: null

    surveyTemplateName: null

    addCopyQuestion: (question) ->
      if question
        newQuestion = this.initializeCopyQuestion(question)

        this.surveyQuestions.push(newQuestion)

        gritterAdd("Successfully added the question to your template.")

    addNewQuestion: ->
      if this.verifyNewQuestion()
        newQuestion = this.initializeCompleteQuestion(this.newQuestion)

        this.surveyQuestions.push(newQuestion)

        this.initializeQuestion()

        this.changeView('survey_template_questions')

        gritterAdd("Successfully added the question to your template.")

    addNewQuestionOption: ->
      if this.newQuestion
        this.newQuestion.question_options.push(this.initializeQuestionOption(null, this.newQuestion.question_options.length + 1))

    bubbleSort: (options) ->
      swapped = true
      i = 0

      while swapped
        count = 0
        while i < options.length
          if options[i + 1] && options[i].question_option > options[i+1].question_option
            temp = options[i]
            options[i] = options[i + 1]
            options[i + 1] = temp

          i += 1

        if count == 0
          swapped = false

        i = 0

      return options

    alphabetizeQuestionOptions: ->
      if this.newQuestion && this.newQuestion.question_options && this.newQuestion.question_options.length > 0
        this.newQuestion.question_options = this.bubbleSort(this.newQuestion.question_options)

        this.reorderOptions()

    changeView: (view) ->
      if view && this.surveyTemplateName && this.surveyTemplateName.length > 0
        this.selectedView = view

        this.setUpView()

      else
        this.selectedView = 'survey_template_name'

    checkIfActive: (tabPane) ->
      if tabPane == this.selectedView
        return 'active'
      else
        return null

    checkNewQuestionOptions: ->
      if this.newQuestion && this.newQuestion.question_options.length > 1
        check = true
        next_index = 0

        _(this.newQuestion.question_options.length).times ->
          if !$scope.newSurveyTemplate.newQuestion.question_options[next_index].question_option || $scope.newSurveyTemplate.newQuestion.question_options[next_index].question_option == ''
            check = false

          next_index += 1

        return check

    confirmEdit: ->
      this.setUpEditTemplate()

      this.selectedView = 'survey_template_name'

    createSurveyTemplate: ->
      if $scope.generalControl.isCampaignPresent()
        survey_template_params = {survey_template_name: this.surveyTemplateName, survey_template_questions: this.surveyQuestions, opening_statement: this.openingStatement, closing_statement: this.closingStatement, is_active: this.is_active, id: this.surveyTemplateId}

        CampaignWizardService.createSurveyTemplate.query({ campaign_id: $scope.generalControl.campaign.id, survey_template_params: survey_template_params }, (responseData) ->
          if responseData.errors == false
            $scope.surveyTemplateControl.getSurveyTemplates()

            if $('#new_survey_template .close') && $('#new_survey_template .close').length > 0
              $('#new_survey_template .close').click()

        )

    editQuestion: (question) ->
      this.isEditingQuestion = true

      this.questionBeingEdited = question

    getQuestionBank: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getQuestionBank.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.newSurveyTemplate.questionBank.multipleChoice = responseData.question_bank.multiple_choice
            $scope.newSurveyTemplate.questionBank.ratingNumber1_10 = responseData.question_bank["rating(numeric1_10)"]
            $scope.newSurveyTemplate.questionBank.ratingNumber1_5 = responseData.question_bank["rating(numeric1_5)"]
            $scope.newSurveyTemplate.questionBank.script = responseData.question_bank.script
            $scope.newSurveyTemplate.questionBank.textFeedback = responseData.question_bank.text_feedback
            $scope.newSurveyTemplate.questionBank.trueFalse = responseData.question_bank["true/false"]
            $scope.newSurveyTemplate.questionBank.yesNo = responseData.question_bank["yes/no"]
        )

    editSurveyTemplateWarningPrompt: ->
      if $scope.surveyTemplateControl.selectedSurveyTemplate && $scope.surveyTemplateControl.selectedSurveyTemplate.id && parseInt($scope.surveyTemplateControl.selectedSurveyTemplate.id, 10) > 0
        $scope.surveyTemplateControl.selectedSurveyTemplate.id

        this.selectedView = 'edit_survey_template_warning_prompt'

        CampaignWizardService.getCampaignTemplatesInUse.query({ survey_template_id: $scope.surveyTemplateControl.selectedSurveyTemplate.id }, (responseData) ->
          if responseData.errors == false
            $scope.newSurveyTemplate.inUseCampaignTemplates = responseData.campaigns
        )

    initializeCopyQuestion: (question) ->
      newQuestion = {

        agent_prompt: question.agent_prompt

        has_options: if question.question_options && question.question_options.length > 0 then true else false

        id: null

        is_active: true

        question_options: this.setUpCopyQuestionOptions(question.question_options)

        question_order: if this.surveyQuestions then this.surveyQuestions.length + 1 else 1

        question_text: question.text

        question_type: question.question_type

        report_question_text: question.report_question_text

      }

      return newQuestion

    initializeCompleteQuestion: (question) ->
      newQuestion = {

        agent_prompt: question.agent_prompt

        has_options: if question.question_options && question.question_options.length > 0 then true else false

        id: null

        is_active: true

        question_options: question.question_options

        question_order: if this.surveyQuestions then this.surveyQuestions.length + 1 else 1

        question_text: question.question_text

        question_type: question.question_type

        report_question_text: question.report_question_text

      }

      return newQuestion

    initializeEditQuestion: (question) ->
      newQuestion = {

        agent_prompt: question.agent_prompt

        has_options: if question.question_options && question.question_options.length > 0 then true else false

        id: question.question_id

        is_active: true

        question_options: this.setUpCopyQuestionOptions(question.question_options)

        question_order: question.order

        question_text: question.text

        question_type: question.question_type

        report_question_text: question.report_question_text

      }

      return newQuestion

    initializeQuestion: (question_type) ->
      this.newQuestion = {
        
        agent_prompt: null

        has_options: false

        id: null

        is_active: true

        question_options: this.setUpQuestionOptions(question_type)

        question_order: if this.surveyQuestions then this.surveyQuestions.length + 1 else 1

        question_text: null

        question_type: question_type

        report_question_text: null

      }

    initializeQuestionOption: (question_option, order) ->
      newOption = {

        is_active: true

        question_option: question_option

        question_option_order: order

        send_survey: false

      }

      return newOption

    readyToSave: ->
      if this.surveyTemplateName && this.surveyTemplateName.length > 0 && this.surveyQuestions && this.surveyQuestions.length > 0 then true else false

    removeErrorMessage: ->
      this.errorMessage = null

    removeOption: (option) ->
      if option && this.newQuestion.question_options.indexOf(option) != (-1)
        index = this.newQuestion.question_options.indexOf(option)
        this.newQuestion.question_options.splice(index, 1)

        this.reorderOptions()

    reorderOptions: ->
      if this.newQuestion.question_options && this.newQuestion.question_options.length > 0
        newIndex = 0

        _(this.newQuestion.question_options.length).times ->
          $scope.newSurveyTemplate.newQuestion.question_options[newIndex].question_option_order = newIndex + 1

          newIndex += 1

      return null

    saveQuestionChanges: ->
      this.isEditingQuestion = false

    setUpCopyQuestionOptions: (question_options) ->
      newQuestionOptions = []

      if question_options && question_options.length > 0

        index = 0
        _(question_options.length).times ->
          question_option = $scope.newSurveyTemplate.initializeQuestionOption(question_options[index].option, question_options[index].order)
          newQuestionOptions.push(question_option)

          index += 1

      return newQuestionOptions

    setUpEditTemplate: ->
      if $scope.surveyTemplateControl.selectedSurveyTemplate
        this.isEditingTemplate = true

        this.surveyTemplateId = $scope.surveyTemplateControl.selectedSurveyTemplate.id
        this.surveyTemplateName = $scope.surveyTemplateControl.selectedSurveyTemplate.survey_template_name

        this.closingStatement = $scope.surveyTemplateControl.selectedSurveyTemplate.closing_statement
        this.openingStatement = $scope.surveyTemplateControl.selectedSurveyTemplate.opening_statement

        if $scope.surveyTemplateControl.surveyQuestions && $scope.surveyTemplateControl.surveyQuestions.length > 0
          index = 0

          _($scope.surveyTemplateControl.surveyQuestions.length).times ->
            newQuestion = $scope.newSurveyTemplate.initializeEditQuestion($scope.surveyTemplateControl.surveyQuestions[index])

            $scope.newSurveyTemplate.surveyQuestions.push(newQuestion)

            index += 1

    setUpInitialCreate: ->
      if $scope.generalControl.campaign.campaign_name && $scope.generalControl.campaign.campaign_name.length > 0
        this.isEditingTemplate = false
        this.surveyTemplateName = $scope.generalControl.campaign.campaign_name
        this.surveyTemplateId = null
        this.surveyQuestions = []
        this.closingStatement = null
        this.openingStatement = null

        this.getQuestionBank()

    setUpQuestionOptions: (question_type) ->
      questionOptions = []

      if question_type == 'multiple_choice'
        questionOptions.push(this.initializeQuestionOption(null, questionOptions.length + 1))
        questionOptions.push(this.initializeQuestionOption(null, questionOptions.length + 1))
        questionOptions.push(this.initializeQuestionOption(null, questionOptions.length + 1))

        return questionOptions
      else if question_type == 'rating_numeric_1-10'
        debugger
      else if question_type == 'rating_numeric_1-5'
        debugger

      else if question_type == 'true_false'
        questionOptions.push(this.initializeQuestionOption('True', questionOptions.length + 1))
        questionOptions.push(this.initializeQuestionOption('False', questionOptions.length + 1))

        return questionOptions          

      else if question_type == 'yes_no'
        questionOptions.push(this.initializeQuestionOption('Yes', questionOptions.length + 1))
        questionOptions.push(this.initializeQuestionOption('No', questionOptions.length + 1))

        return questionOptions

      else
        return questionOptions

    setUpView: ->
      if this.selectedView == 'multiple_choice'
        this.initializeQuestion('multiple_choice')
      if this.selectedView == 'rating_numeric1_10'
        this.initializeQuestion('rating_numeric_1-10')
      if this.selectedView == 'rating_numeric1_5'
        this.initializeQuestion('rating_numeric_1-5')
      if this.selectedView == 'script'
        this.initializeQuestion('script')
      if this.selectedView == 'text_feedback'
        this.initializeQuestion('text_feedback')
      if this.selectedView == 'true_false'
        this.initializeQuestion('true_false')
      if this.selectedView == 'yes_no'
        this.initializeQuestion('yes_no')

    returnToQuestionOrderView: ->
      this.isEditingQuestion = false

    verifyNewQuestion: ->
      if this.newQuestion
        if !this.newQuestion.question_text || this.newQuestion.question_text == ''
          this.errorMessage = "Your question MUST have question text."
          gritterAdd("Your new question MUST have question text.")

          return null

        else if this.newQuestion.question_type == 'multiple_choice' && this.newQuestion.question_options.length <= 1
          this.errorMessage = "Multiple choice questions MUST have at least TWO options."
          gritterAdd("Multiple choice questions MUST have at least TWO options.")

          return null

        else if this.newQuestion.question_type == 'multiple_choice' && !this.checkNewQuestionOptions()
          this.errorMessage = "Your question options MUST ALL have option text."
          gritterAdd("Your question options MUST ALL have option text.")

          return null

        else
          this.errorMessage = null
          return true

  }

  $scope.surveyTemplateControl = {

    closingStatement: null

    displayInstruction1: true

    displayInstruction2: true

    displayInstruction3: true

    displayInstruction4: true

    displayInstruction5: true

    isGettingSelectedTemplate: false

    openingStatement: null

    selectedSurveyTemplate: null

    surveyQuestions: []

    surveyTemplates: []

    copyExistingTemplate: ->
      if $scope.generalControl.isCampaignPresent() && this.selectedSurveyTemplate && this.selectedSurveyTemplate.id && this.selectedSurveyTemplate.id > 0
        this.isGettingSelectedTemplate = true

        CampaignWizardService.copyExistingTemplate.query({ campaign_id: $scope.generalControl.campaign.id, copy_survey_template_id: this.selectedSurveyTemplate.id }, (responseData) ->          
          if responseData.errors == false
            $scope.surveyTemplateControl.surveyTemplates = responseData.survey_templates
            $scope.surveyTemplateControl.selectedSurveyTemplate = setCurrentSurveyTemplate(responseData.data.survey.survey_template_id)
            $scope.surveyTemplateControl.surveyQuestions = responseData.data.survey.questions
            $scope.surveyTemplateControl.openingStatement = responseData.data.survey.opening_statement
            $scope.surveyTemplateControl.closingStatement = responseData.data.survey.closing_statement
            $scope.surveyTemplateControl.isGettingSelectedTemplate = false

            if $('.modal#copy_existing_survey_template .modal-footer .btn[data-dismiss="modal"]') && $('.modal#copy_existing_survey_template .modal-footer .btn[data-dismiss="modal"]').length > 0
              $('.modal#copy_existing_survey_template .modal-footer .btn[data-dismiss="modal"]')[0].click()

              if $('#edit_survey_template') && $('#edit_survey_template').length > 0
                $scope.newSurveyTemplate.confirmEdit()
                
                $('#edit_survey_template')[0].click()

            return null
        )

    getSurveyTemplates: ->
      if $scope.generalControl.isCampaignPresent()
        CampaignWizardService.getSurveyTemplates.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
          if responseData.errors == false
            $scope.surveyTemplateControl.surveyTemplates = responseData.survey_templates

            if responseData.data && responseData.data.survey && responseData.data.survey.survey_template_id && $scope.surveyTemplateControl.surveyTemplates && $scope.surveyTemplateControl.surveyTemplates.length > 0
              $scope.surveyTemplateControl.selectedSurveyTemplate = setCurrentSurveyTemplate(responseData.data.survey.survey_template_id)
              $scope.surveyTemplateControl.surveyQuestions = responseData.data.survey.questions
              $scope.surveyTemplateControl.openingStatement = responseData.data.survey.opening_statement
              $scope.surveyTemplateControl.closingStatement = responseData.data.survey.closing_statement
              $scope.surveyTemplateControl.questionTypes = responseData.type_data.question_types
        )
      else
        gritterAdd("Please enter a campaign name and update before moving on.")
        $scope.tabViewControl.changeView('general')

    getSelectedSurveyTemplate: ->
      this.isGettingSelectedTemplate = true

      CampaignWizardService.getSelectedSurveyTemplate.query({ survey_template_id: this.selectedSurveyTemplate.id }, (responseData) ->
        $scope.surveyTemplateControl.surveyQuestions = responseData.data.survey.questions
        $scope.surveyTemplateControl.openingStatement = responseData.data.survey.opening_statement
        $scope.surveyTemplateControl.closingStatement = responseData.data.survey.closing_statement
        $scope.surveyTemplateControl.isGettingSelectedTemplate = false
      )

    setInstructionDisplay1: (boolean) ->
      this.displayInstruction1 = boolean

    setInstructionDisplay2: (boolean) ->
      this.displayInstruction2 = boolean

    setInstructionDisplay3: (boolean) ->
      this.displayInstruction3 = boolean

    setInstructionDisplay4: (boolean) ->
      this.displayInstruction4 = boolean

    setInstructionDisplay5: (boolean) ->
      this.displayInstruction5 = boolean

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent() && this.selectedSurveyTemplate && this.selectedSurveyTemplate.id && parseInt(this.selectedSurveyTemplate.id, 10) > 0
        campaign_params = {survey_template_id: this.selectedSurveyTemplate.id}
        CampaignWizardService.updateCampaign.query({ campaign_id: $scope.generalControl.campaign.id, campaign_params: campaign_params }, (responseData) ->
          if responseData.errors == false
            $scope.campaignProgressControl.requirements.survey_template = true
            $scope.campaignProgressControl.performSurveyTemplateCheck()
            $scope.campaignProgressControl.afterSaveActiveCheck()

            $scope.tabViewControl.changeView('twilio_number')
        )

  }

  $scope.surveyTemplateControlFirst = {

    closingStatement: null

    exampleOption: null

    newSurveyTemplate: {

      closingStatement: null

      newSurveyQuestions: []

      openingStatement: null

      questionsView: true

      selectedQuestionType: null

      surveyTemplateName: null

      voicemailMessage: null

      addNewQuestion: ->
        if this.selectedQuestionType
          this.newSurveyQuestions.push(this.initializeQuestion())

          this.selectedQuestionType = null

      changeView: ->
        if this.questionsView == true
          this.questionsView = false
        else
          this.questionsView = true

      initializeQuestionOption: (question_option, order) ->
        newOption = {

          is_active: true

          question_option: question_option

          question_option_order: order

          send_survey: false

        }

        return newOption

      resetQuestionType: (question) ->
        if question && question.question_type
          question_type_index = findQuestionTypeIndex(question.question_type.id)
          
          question.question_type = $scope.stage1Control.questionTypes[question_type_index]
          
          if question.question_type
            question.question_options = this.setUpQuestionOptions(question.question_type.question_type)

      setDropdownQuestionType: (question_type) ->
        if question_type
          question_type_index = findQuestionTypeIndex(question_type.id)
          
          return $scope.stage1Control.questionTypes[question_type_index]



    }

    openingStatement: null

    questionTypes: []

    selectedSurveyTemplate: null

    selectedView: 'default'

    surveyQuestions: []

    surveyTemplates: []

    changeView: (viewTemplate) ->
      if viewTemplate == 'agent_view'
        this.selectedView = 'agent_view'
      else if viewTemplate == 'edit_survey_template'
        this.selectedView = 'edit_survey_template'
        # debugger
      else if viewTemplate == 'new_survey_template'
        this.selectedView = 'new_survey_template'
      else
        this.selectedView = 'default'

    getSurveyTemplates: ->
      CampaignWizardService.getSurveyTemplates.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
        if responseData.errors == false
          $scope.stage1Control.surveyTemplates = responseData.survey_templates

          if responseData.data && responseData.data.survey && responseData.data.survey.survey_template_id && $scope.stage1Control.surveyTemplates && $scope.stage1Control.surveyTemplates.length > 0
            $scope.stage1Control.selectedSurveyTemplate = setCurrentSurveyTemplate(responseData.data.survey.survey_template_id)
            $scope.stage1Control.surveyQuestions = responseData.data.survey.questions
            $scope.stage1Control.openingStatement = responseData.data.survey.opening_statement
            $scope.stage1Control.closingStatement = responseData.data.survey.closing_statement
            $scope.stage1Control.questionTypes = responseData.type_data.question_types
      )

    getSelectedSurveyTemplate: ->
      CampaignWizardService.getSelectedSurveyTemplate.query({ survey_template_id: this.selectedSurveyTemplate.id }, (responseData) ->
        $scope.stage1Control.surveyQuestions = responseData.data.survey.questions
        $scope.stage1Control.openingStatement = responseData.data.survey.opening_statement
        $scope.stage1Control.closingStatement = responseData.data.survey.closing_statement
      )

    updateAndNextStep: ->
      CampaignWizardService.updateStage1AndNextStep.query({ campaign_id: $scope.campaign.id, survey_template_id: this.selectedSurveyTemplate.id }, (responseData) ->
        if responseData.errors == false
          gritterAdd("Successfully updated the survey template.")

          window.location = '/dealers/' + $scope.campaign.dealer_id + '/campaigns/' + $scope.campaign.id + '/edit?stage=' + responseData.next_stage
      )

  }

################################################################
################# Tab View Control #############################

  $scope.tabViewControl = {

    selectedView: 'general'

    changeView: (view) ->
      if view && $scope.generalControl.campaign && $scope.generalControl.campaign.campaign_name && $scope.generalControl.campaign.campaign_name.length > 0
        this.selectedView = view

        this.setUpView()
      else
        this.selectedView = 'general'

    checkIfActive: (tabPane) ->
      if tabPane == this.selectedView
        return 'active'
      else
        return null

    setUpView: ->
      if this.selectedView == 'campaign_progress'
        $scope.campaignProgressControl.checkIfRequirementsCompleted()
      if this.selectedView == 'survey_template' && $scope.surveyTemplateControl.surveyTemplates && $scope.surveyTemplateControl.surveyTemplates.length == 0
        $scope.surveyTemplateControl.getSurveyTemplates()
      if this.selectedView == 'twilio_number' && $scope.twilioNumberControl.twilioNumbers && $scope.twilioNumberControl.twilioNumbers.length == 0
        $scope.twilioNumberControl.getTwilioNumbers()
      if this.selectedView == 'call_queues' && $scope.callQueuesControl.callQueues && $scope.callQueuesControl.callQueues.length == 0
        $scope.callQueuesControl.setUpCallQueues()
      if this.selectedView == 'attempts' && $scope.attemptsControl.voicemailAttempts && $scope.attemptsControl.voicemailAttempts.length == 0
        $scope.attemptsControl.getCampaignAttempts()
      if this.selectedView == 'dispositions' && $scope.dispositionsControl.excludedDispositions && $scope.dispositionsControl.excludedDispositions.length == 0 && $scope.dispositionsControl.includedDispositions && $scope.dispositionsControl.includedDispositions.length == 0
        $scope.dispositionsControl.getDispositions()
      if this.selectedView == 'alerts' && $scope.alertsControl.employeeAlerts && $scope.alertsControl.employeeAlerts.length == 0
        $scope.alertsControl.getCampaignEmployeeAlerts()
      if this.selectedView == 'query_params' && $scope.queryParamsControl.hasGotCriterionDetails == false
        $scope.queryParamsControl.getCampaignCriterions()
      if this.selectedView == 'settings' && $scope.settingsControl.hasGotDetails == false
        $scope.settingsControl.getSettingsDetails()
      if this.selectedView == 'run_campaign'
        $scope.runCampaignControl.canMakeActive()

  }

################################################################
################# Twilio Number Control ########################

  $scope.twilioNumberControl = {

    areaCode: null

    countries: []

    displayInstruction: true

    errorMessage: null

    isCreating: false

    numberTypes: []

    selectedCountry: null

    selectedNumberType: null

    selectedTwilioNumber: null

    twilioNumbers: []

    areaCodeVerify: ->
      if !this.selectedNumberType
        this.errorMessage = "Please select a number type for your area code."

      else if !this.selectedCountry
        this.errorMessage = "Please select a country for your area code."

      else if !this.areaCode || this.areaCode == ''
        this.errorMessage = "Please enter an area code."

      else if this.areaCode.length != 3
        this.errorMessage = "Area code must be 3 numbers long."

      else if !this.isNumber(this.areaCode)
        this.errorMessage = "The Area Code must consist of only numbers."

      else if this.selectedNumberType.type == "Toll Free" && this.checkFirstNumber(this.areaCode[0])
        this.errorMessage = "Toll Free Numbers cannot begin with 0 or 1. Please enter a new area code."

      else
        this.errorMessage = null

        this.createTwilioNumber()

    checkFirstNumber: (firstDigit) ->
      if firstDigit
        console.log(firstDigit)
        if (parseInt(firstDigit, 10) == 0 || parseInt(firstDigit, 10) == 1) then true else false

      else
        false

    createTwilioNumber: ->
      if this.areaCode && this.selectedNumberType && $scope.generalControl.isCampaignPresent() && $scope.twilioNumberControl.selectedCountry && $scope.twilioNumberControl.selectedCountry.length > 0
        this.isCreating = true

        CampaignWizardService.createTwilioNumber.query({ campaign_id: $scope.generalControl.campaign.id, number_type: this.selectedNumberType.type, area_code: this.areaCode, country: this.selectedCountry }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.twilioNumberControl.twilioNumbers = responseData.twilio_numbers
            $scope.twilioNumberControl.selectedTwilioNumber = setCurrentTwilioNumber(responseData.selected_twilio_id)
            $scope.twilioNumberControl.isCreating = false

            if $('#create_new_twilio_number .close') && $('#create_new_twilio_number .close').length > 0
              $('#create_new_twilio_number .close').click()
        )

      return null

    getCountries: ->
      if $scope.generalControl.isCampaignPresent() && this.countries.length == 0
        CampaignWizardService.getCountries.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) -> 
          if responseData.errors == false
            $scope.twilioNumberControl.countries = responseData.countries
            $scope.twilioNumberControl.selectedCountry = $scope.twilioNumberControl.setUpSelectedDefaultCountry(responseData.default_country)
        )

    getTwilioNumbers: ->
      CampaignWizardService.getTwilioNumbers.query({ campaign_id: $scope.generalControl.campaign.id }, (responseData) ->
        if responseData.errors == false
          $scope.twilioNumberControl.twilioNumbers = responseData.twilio_numbers

          if responseData.selected_twilio_id && parseInt(responseData.selected_twilio_id, 10) > 0
            $scope.twilioNumberControl.selectedTwilioNumber = setCurrentTwilioNumber(responseData.selected_twilio_id)
      )

    isNumber: (areaCode) ->
      if areaCode
        pattern = /^\d+$/im

        return areaCode.match pattern ;
      else
        false

    setUpSelectedDefaultCountry: (defaultCountry) ->
      next_index = 0
      desired_index = (-1)
      _($scope.twilioNumberControl.countries.length).times ->
        if $scope.twilioNumberControl.countries[next_index] && $scope.twilioNumberControl.countries[next_index].code == defaultCountry
          desired_index = next_index

        next_index += 1

      if desired_index >= 0
        return $scope.twilioNumberControl.countries[desired_index].code
      else
        return null

    setInstructionDisplay: (boolean) ->
      this.displayInstruction = boolean

    setUpNumberTypes: ->
      if this.numberTypes && this.numberTypes.length == 0
        this.numberTypes.push({type: "Local"})
        this.numberTypes.push({type: "Toll Free"})

    setUpTwilioModal: ->
      this.setUpNumberTypes()
      this.getCountries()

    updateAndNextStep: ->
      if $scope.generalControl.isCampaignPresent() && this.selectedTwilioNumber && this.selectedTwilioNumber.id != $scope.generalControl.campaign.twilio_number_id
        CampaignWizardService.updateTwilioDetails.query({ campaign_id: $scope.generalControl.campaign.id, twilio_number_id: this.selectedTwilioNumber.id }, (responseData) ->
          if responseData.errors == false
            $scope.generalControl.campaign = responseData.campaign
            $scope.callQueuesControl.callQueues = []

            if $scope.generalControl.campaign.twilio_number_id && $scope.generalControl.campaign.twilio_number_id > 0
              $scope.campaignProgressControl.requirements.twilio_number = true
              $scope.campaignProgressControl.performTwilioNumberCheck()

            $scope.tabViewControl.changeView('call_queues')
        )

      else if $scope.generalControl.isCampaignPresent()
        $scope.tabViewControl.changeView('call_queues')

      else
        gritterAdd("Something went wrong.")

  }

################################################################
################# Initialize ###################################

  init()

]