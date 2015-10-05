surveyApp.factory 'CampaignWizardService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  campaignDispositionUpdate: $resource "/campaign_disposition_update_2.json", {}, query: { method: 'GET', isArray: false }

  campaignDispositionPriceUpdate: $resource "/campaign_disposition_price_update_2.json", {}, query: { method: 'GET', isArray: false }

  canMakeActive: $resource "/can_make_active.json", {}, query: { method: 'GET', isArray: false }

  checkIfRequirementsCompleted: $resource "/check_if_requirements_completed.json", {}, query: { method: 'GET', isArray: false }

  copyExistingTemplate: $resource "/copy_existing_survey_template.json", {}, query: { method: 'GET', isArray: false }

  createCallQueue: $resource "/create_call_queue.json", {}, query: { method: 'GET', isArray: false }

  createCampaign: $resource "/create_campaign.json", {}, query: { method: 'GET', isArray: false }

  createCampaignCriterion: $resource "/create_campaign_criterion.json", {}, query: { method: 'GET', isArray: false }

  createDealerEmployee: $resource "/create_dealer_employee.json", {}, query: { method: 'GET', isArray: false }  

  createNewDisposition: $resource "/create_disposition.json", {}, query: { method: 'GET', isArray: false }

  createSurveyTemplate: $resource "/create_survey_template_with_questions.json", {}, query: { method: 'GET', isArray: false }

  createTwilioNumber: $resource "/create_twilio_number.json", {}, query: { method: 'GET', isArray: false }

  destroyCallQueue: $resource "/destroy_call_queue.json", {}, query: { method: 'GET', isArray: false }

  destroyDealerEmployee: $resource "/destroy_dealer_employee.json", {}, query: { method: 'GET', isArray: false }

  disableCriterion: $resource "/disable_criterion.json", {}, query: { method: 'GET', isArray: false }

  getCampaignAttempts: $resource "/get_campaign_attempts.json", {}, query: { method: 'GET', isArray: false }

  getCampaignCriterions: $resource "/get_campaign_criterions.json", {}, query: { method: 'GET', isArray: false }

  getCampaignEmployeeAlerts: $resource "/get_campaign_employee_alerts.json", {}, query: { method: 'GET', isArray: false }

  getCampaignInformation: $resource "/get_campaign_information.json", {}, query: { method: 'GET', isArray: false }

  getCampaignTemplatesInUse: $resource "/get_campaign_templates_in_use.json", {} ,query: { method: 'GET', isArray: false }

  getCountries: $resource "/get_countries.json", {}, query: { method: 'GET', isArray: false }

  getDealerLaborTypes: $resource "/get_labor_types.json", {}, query: { method: 'GET', isArray: false }

  getDealerEmployeeCreationInformation: $resource "/get_dealer_employee_creation_information.json", {}, query: { method: 'GET', isArray: false }

  getDispositions: $resource "/get_dispositions.json", {}, query: { method: 'GET', isArray: false }
  
  getOperationalCodes: $resource "/get_operational_codes.json", {}, query: { method: 'GET', isArray: false }

  getQuestionBank: $resource "/get_question_bank.json", {}, query: { method: 'GET', isArray: false }

  getPusherKey: $resource "/pusher_api_key.json", {}, query: { method: 'GET', isArray: false }
  
  getSelectedSurveyTemplate: $resource "/get_selected_survey_template.json", {}, query: { method: 'GET', isArray: false }
  
  getSettingsDetails: $resource "/get_settings_details.json", {}, query: { method: 'GET', isArray: false }

  getSurveyTemplates: $resource "/get_survey_templates.json", {}, query: { method: 'GET', isArray: false }
  
  getTwilioNumbers: $resource "/get_twilio_numbers.json", {}, query: { method: 'GET', isArray: false }

  resetDispositions: $resource "/reset_campaign_dispositions.json", {}, query: { method: 'GET', isArray: false }

  setUpCallQueues: $resource "/set_up_call_queues.json", {}, query: { method: 'GET', isArray: false }
  
  updateAttempts: $resource "/update_attempts.json", {}, query: { method: 'GET', isArray: false }

  updateCampaign: $resource "/update_campaign.json", {}, query: { method: 'GET', isArray: false }
  
  updateCampaignSurveyAlert: $resource "/update_campaign_survey_alert.json", {}, query: { method: 'GET', isArray: false }

  updateCriterion: $resource "/update_criterion.json", {}, query: { method: 'GET', isArray: false }

  updateStage1AndNextStep: $resource "/update_stage_1_and_next_step.json", {}, query: { method: 'GET', isArray: false }

  updateTwilioDetails: $resource "/update_twilio_details.json", {}, query: { method: 'GET', isArray: false }
]