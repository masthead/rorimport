#=require underscore

$ ->

  $("#dispo_btnSelect").click ->
    $("#selectedBox1 option:selected").each ->
      disposition = $(this)
      disposition_id = disposition.attr("data-id")
      updateDisposition(disposition_id,  "add")
      disposition.remove()
      return
    false

  $("#dispo_btnRemove").click ->
    $("#selectedBox2 option:selected").each ->
      disposition = $(this)
      disposition_id = disposition.attr("data-id")
      updateDisposition(disposition_id, "remove")

      disposition_option = '<option data-id="' + disposition_id + '" value="' + disposition[0].value + '">' + disposition[0].value + '</option>'
      $('#selectedBox1').append(disposition_option)
      disposition.remove()

      gritterAdd("Successfully removed the disposition from your campaign.")

      return
    false

  $("#dispo_btnRemoveAll").click ->
    $("#selectedBox2 option").each ->
      disposition = $(this)
      disposition_id = disposition.attr("data-id")
      updateDisposition(disposition_id, "remove")
      
      disposition_option = '<option data-id="' + disposition_id + '" value="' + disposition[0].value + '">' + disposition[0].value + '</option>'
      $('#selectedBox1').append(disposition_option)
      disposition.remove()

      return

    false

    gritterAdd("Successfully removed all of the dispositions from your campaign.")

  return

addDisposition = ->
  price = $('#price-dispositions-modal .form-group #disposition_price')[0].value.replace("$", "").replace(" ", "")
  make_default_price = $('#price-dispositions-modal .form-group #make_default_price')[0].checked
  campaign_id = $("#campaign_identifier").attr("data-id")
  action = "add"

  if campaign_id && parseInt(campaign_id, 10) > 0
    ajaxLoader("body")
    $.ajax(
      type: "GET"
      url: "/campaign_disposition_update"
      dataType: "json"
      data:
        campaign_id: campaign_id
        campaign_disposition_action: action
        disposition_id: $('#price-dispositions-modal .disposition_id')[0].value
        price: price
        make_default_price: make_default_price
    ).success (data) ->
      $(".ajax_overlay").first().fadeOut()
      console.log("Successful")

      if data.errors == false
        disposition = '<option data-id="' + data.disposition.id + '" value="' + data.disposition.disposition_description + '">' + data.disposition.disposition_description + ' ($' + data.disposition_price + ')</option>'
        $('#selectedBox2').append(disposition)

        gritterAdd("Successfully added the disposition to your campaign.")

      else
        gritterAdd("Something went wrong. Please reload the browser and if the error persits, please contact DealerFocus today.")

watchForPriceSave = ->
  $("#price-dispositions-modal .modal-footer #save_disposition_price").click ->
    addDisposition()
  
  $("#price-dispositions-modal .modal-footer #close_disposition_price").click ->
    addDisposition()


updateDisposition = (disposition_id, action) ->
  url = "/campaign_disposition_update"
  campaign_id = $("#campaign_identifier").attr("data-id")

  console.log(disposition_id)
  console.log(action)

  if action == 'add'
    console.log('adding')
    $("#price-dispositions-modal").modal("show").removeClass('hide');
    $('#price-dispositions-modal .disposition_id')[0].value = disposition_id
    watchForPriceSave()

  else if action == 'remove'
    ajaxLoader("body")
    $.ajax(
      type: "GET"
      url: url
      dataType: "json"
      data:
        campaign_id: campaign_id
        campaign_disposition_action: action
        disposition_id: disposition_id
    ).success (data) ->
      $(".ajax_overlay").first().fadeOut()

  return null

disposition_price_update =
  init: ->
    do @watchForClick

  watchForClick: ->
    $("#dispo_priceUpdate").click ->
      $("#selectedBox2 option:selected").each ->
        disposition = $(this)
        disposition_id = disposition.attr("data-id")
        $("#price-update-dispositions-modal").modal("show").removeClass('hide');
        $('#price-update-dispositions-modal .disposition_id')[0].value = disposition_id
        
        disposition_price_update.watchForPriceUpdate()
        return
      false

  watchForPriceUpdate: ->
    $('#price-update-dispositions-modal .modal-footer #update_disposition_price').click ->
      disposition_price_update.updateDispositionPrice()

  updateDispositionPrice: ->
    campaign_id = $("#campaign_identifier").attr("data-id")
    price = $('#price-update-dispositions-modal .form-group #disposition_price')[0].value.replace("$", "").replace(" ", "")
    make_default_price = $('#price-update-dispositions-modal .form-group #make_default_price')[0].checked
    disposition_id = $('#price-update-dispositions-modal .disposition_id')[0].value

    if campaign_id && parseInt(campaign_id, 10) > 0 && disposition_id && parseInt(disposition_id, 10) > 0

      ajaxLoader("body")
      $.ajax(
        type: "POST"
        url: '/campaign_disposition_price_update'
        dataType: "json"
        data:
          campaign_id: campaign_id
          disposition_id: disposition_id
          price: price
          make_default_price: make_default_price
      ).success (data) ->
        $(".ajax_overlay").first().fadeOut()

        if data.errors == false
          if $("#selectedBox2 > option[data-id='" + data.disposition_id + "'") && $("#selectedBox2 > option[data-id='" + data.disposition_id + "'").length > 0
            disposition = $("#selectedBox2 > option[data-id='" + data.disposition_id + "'")[0]
            
            disposition.value = data.disposition_description + ' ($' + data.updated_price + ')'
            disposition.innerHTML = data.disposition_description + ' ($' + data.updated_price + ')'

            gritterAdd("Successfully updated the disposition price.")

        else
          gritterAdd("Something went wrong. Please reload the browser and if the error persits, please contact DealerFocus today.")



voice_mails =
  init: ->
  #   _.templateSettings =  interpolate :/\{\{(.+?)\}\}/g
  #   do @addNewMessage
  #   do @removeMessage
  #   do @upMessage
  #   do @downMessage

  # upMessage: ->
  #   $("body").on "click" , ".up-voice-mail-message" , (event) ->
  #     event.preventDefault()
  #     row = $(@).parents('.voice-mail-message').first()
  #     hidden_input = $(row).next('input')
  #     before_row = $(row).prevAll('.voice-mail-message').first()
  #     new_row = row.detach()
  #     new_hidden_input = hidden_input.detach()
  #     if before_row.length > 0
  #       before_row.before(new_row)
  #     else
  #       $('.voice-mail-messages').append(new_row)
  #     new_row.after(new_hidden_input)
  #     voice_mails.distributeAttemptsNumber()

  # downMessage: ->
  #   $("body").on "click" , ".down-voice-mail-message" , (event) ->
  #     event.preventDefault()
  #     row = $(@).parents('.voice-mail-message').first()
  #     hidden_input = $(row).next('input')
  #     next_row = $(row).nextAll('.voice-mail-message').first()
  #     new_row = row.detach()
  #     new_hidden_input = hidden_input.detach()
  #     if next_row.length > 0
  #       next_row.after(new_row)
  #     else
  #       $('.voice-mail-messages').prepend(new_row)
  #     new_row.after(new_hidden_input)
  #     voice_mails.distributeAttemptsNumber()

  # addNewMessage: ->
  #   $("body").on "click" , "#new-attempt" , (event) ->
  #     event.preventDefault()
  #     $.ajax(
  #       type: "post"
  #       url: "/create_campaign_voice_mail.json"
  #       data:
  #         campaign_id: $('#campaign_id').val()
  #     ).done (data) ->
  #       unless data.errors
  #         id = $(".voice-mail-message").length;
  #         response_data = { id: id, id_new_message: data.voice_mail_id }
  #         template = _.template($.trim($("#new-voice-template").html()))
  #         quest = template(response_data)
  #         $(".voice-mail-messages").prepend(quest)
  #         voice_mails.recalculateCount(1)

  # removeMessage: ->
  #   $("body").on "click" , ".remove-voice-mail-message" , (event) ->
  #     event.preventDefault()
  #     row = $(@).parents('.voice-mail-message')
  #     hidden_input = $(row).next('input')
  #     $.ajax(
  #       type: "post"
  #       url: "/remove_campaign_voice_mail.json"
  #       data:
  #         campaign_id: $('#campaign_id').val(),
  #         voice_mail_id: hidden_input.val()
  #     ).done (data) ->
  #       unless data.errors
  #         $(hidden_input).remove()
  #         $(row).remove()
  #         voice_mails.recalculateCount(-1)

  # recalculateCount: (i) ->
  #   old_val = $("#max-attempts-count").html()
  #   $("#max-attempts-count").html(parseInt(old_val, 10) + i)
  #   voice_mails.distributeAttemptsNumber()

  # distributeAttemptsNumber: ->
  #   $.each $(".voice-mail-message"), (i, e) ->
  #     $(e).find('input.attempt').val(i + 1)

campaign_groups =
  init: ->
    do @newCampaignGroup
    do @newCampaignGroupCancel
    do @createCampaignGroup

  newCampaignGroup: ->
    $('body').on 'click' , '#new-campaign-group-button' , (event) -> 
      event.preventDefault();
      $("#new-campaign-group-modal").modal("show").removeClass('hide');

  newCampaignGroupCancel: ->
    $("body").on "click" , "#new-campaign-group-cancel" , (event) ->
      event.preventDefault();
      $("#new-campaign-group-modal").modal('hide');
      campaign_groups.clearForm('#new-campaign-group-form');

  createCampaignGroup: ->
    $('#new-campaign-group-form').on 'click', "button[type=\"submit\"]", (e) ->
      event.preventDefault();
      params = $(@).closest("form").serializeArray();
      input_data = {}
      $.each params, (i, e) ->
        input_data[e.name] = e.value;
      campaign_group_name = input_data['campaign_group[campaign_group_name]'];
      if campaign_group_name.length > 0
        $.ajax(
          type: "post"
          url: "/create_campaign_group.json"
          data: input_data
        ).done (data) ->
          unless data.errors
            campaign_groups.addNewCampaignGroupToList(campaign_group_name, data.campaign_group_id);

  addNewCampaignGroupToList: (name, campaign_group_id) ->
    $('.form-control.input-sm.chosen-select#campaign_campaign_group_id').prepend(
      '<option selected="selected" value="' + campaign_group_id + '">' + name + '</option>');
    $("select").trigger("chosen:updated"); 

    campaign_groups.clearForm('#new-disposition-form');
    $("#new-campaign-group-modal").modal('hide');            

  clearForm: (form) ->
    $(form).find("input[type=text], textarea").val("");
    $(form).find("input[type=checkbox]").removeAttr('checked');      

dispos_cats =
  init: ->
    #TODO REFactoring(compare functions for dispositions and categories)
    do @newDisposition
    do @newDispositionCancel
    do @createDisposition
    do @newCategory
    do @newCategoryCancel
    do @createCategory

  newDisposition: ->
    $("body").on "click" , "#new-disposition-button" , (event) ->
      event.preventDefault()
      $("#create-dispositions-modal").modal("show").removeClass('hide');

  newCategory: ->
    $("body").on "click" , "#new-category-button" , (event) ->
      event.preventDefault()
      $("#new-category-modal").modal("show").removeClass('hide');

  newDispositionCancel: ->
    $("body").on "click" , "#new-disposition-cancel" , (event) ->
      event.preventDefault()
      $("#new-disposition-modal").modal('hide')
      dispos_cats.clearForm('#new-disposition-form')

  newCategoryCancel: ->
    $("body").on "click" , "#new-category-cancel" , (event) ->
      event.preventDefault()
      $("#new-category-modal").modal('hide')
      dispos_cats.clearForm('#new-category-form')

  createDisposition: ->
    $('#create_disposition').click ->

      campaign_id = $('#create-dispositions-modal #campaign_id')[0].value;
      disposition_description = $('#create-dispositions-modal #disposition-name')[0].value;
      tooltip_text = $('#create-dispositions-modal #disposition-tooltip-text')[0].value
      price = $('#create-dispositions-modal #disposition-price')[0].value;
      denotes_appointment = $('#create-dispositions-modal #disposition-appointment')[0].checked
      denotes_contact = $('#create-dispositions-modal #disposition-contact')[0].checked
      is_complete = $('#create-dispositions-modal #disposition-completion')[0].checked
      is_default = $('#create-dispositions-modal #disposition-default')[0].checked
      denotes_callback = $('#create-dispositions-modal #disposition-callback')[0].checked
      send_survey = $('#create-dispositions-modal #disposition-send_survey')[0].checked
      
      if disposition_description.length > 0
        $.ajax(
          type: "post"
          url: "/create_campaign_disposition.json"
          data:
            campaign_id: campaign_id
            disposition_description: disposition_description
            tooltip_text: tooltip_text
            price: price
            denotes_appointment: denotes_appointment
            denotes_contact: denotes_contact
            is_complete: is_complete
            is_default: is_default
            denotes_callback: denotes_callback
            send_survey: send_survey
        ).done (data) ->
          unless data.errors
            disposition = '<option data-id="' + data.disposition.id + '" value="' + data.disposition.disposition_description + '">' + data.disposition.disposition_description + ' ($' + data.disposition_price + ')</option>'
            $('#selectedBox2').append(disposition)

  createCategory: ->
    $("#new-category-form").on "click", "button[type=\"submit\"]", (e) ->
      event.preventDefault()
      params = $(@).closest("form").serializeArray()
      input_data = {}
      $.each params, (i, e) ->
        input_data[e.name] = e.value
      category_name = input_data['category[category_name]']
      if category_name.length > 0
        $.ajax(
          type: "post"
          url: "/create_campaign_category.json"
          data: input_data
        ).done (data) ->
          unless data.errors
            dispos_cats.addNewCatToList(category_name, data.category_id)

  addNewCatToList: (name, id) ->
    $('.categories').prepend(
        '<div class="category col-md-4">
                      <input checked="checked" class="campaign-categories" id="category_' + id + '" name="campaign[category_ids][]" type="checkbox" value="1">
                  <label class="campaign-categories" for="category_' + id + '">' + name + '</label>
                  </div>')
    dispos_cats.clearForm('#new-category-form')
    $("#new-category-modal").modal('hide')

  addNewDisposToList: (name, id) ->
    $('.dispositions').prepend(
        '<div class="disposition col-md-4">
              <input checked="checked" class="campaign-dispositions" id="disposition_' + id + '" name="campaign[disposition_ids][]" type="checkbox" value="1">
            <label class="campaign-dispositions" for="disposition_' + id + '">' + name + '</label>
            </div>')
    dispos_cats.clearForm('#new-disposition-form')
    $("#new-disposition-modal").modal('hide')

  clearForm: (form) ->
    $(form).find("input[type=text], textarea").val("")
    $(form).find("input[type=checkbox]").removeAttr('checked')

reset_dispos = 
  init: ->
    do @resetConfirmation
    do @resetAllDispositions

  resetConfirmation: ->
    $("body").on "click" , "#reset-dispositions-button" , (event) ->
      event.preventDefault()
      $("#reset-dispositions-default-modal").modal("show").removeClass('hide');

  resetAllDispositions: ->
    $('#confirm-reset-dispositions').click ->
      campaign_id = $('#reset-dispositions-default-modal #campaign_id')[0].value

      if campaign_id && parseInt(campaign_id, 10) > 0
        ajaxLoader("body")
        $.ajax(
          type: "post"
          url: "/reset_campaign_dispositions.json"
          data:
            campaign_id: campaign_id
        ).done (data) ->
          unless data.errors

            debugger;

            # Remove unselected dispositions from page
            $('#selectedBox1').empty()

            # Append other dispositions to unselected section
            next_index = 0
            _(data.other_dispositions.length).times ->
              disposition_option = '<option data-id="' + data.other_dispositions[next_index].id + '" value="' + data.other_dispositions[next_index].disposition_description + '">' + data.other_dispositions[next_index].disposition_description + '</option>'
              $('#selectedBox1').append(disposition_option)

              next_index += 1

            # Remove currently selected dispostitions
            $('#selectedBox2').empty()
            next_index = 0
            _(data.default_dispositions.length).times ->
              disposition_option = '<option data-id="' + data.default_dispositions[next_index].id + '" value="' + data.default_dispositions[next_index].disposition_description + '">' + data.default_dispositions[next_index].disposition_description + ' (0.00)</option>'
              $('#selectedBox2').append(disposition_option)

              next_index += 1

            $(".ajax_overlay").first().fadeOut()
            console.log("Reset to default")
            gritterAdd("Successfully reset your campaign dispositions to default.")

          else
            gritterAdd("Something went wrong. Please reload the browser and if the error persits, please contact DealerFocus today.")


  removeCheckFromPage: ->
    for key, i in $('.campaign-dispositions[checked="checked"]')
      $(key)[0].checked = false
      $(key)[0].removeAttribute("checked")  

  checkDefaultDispositions: (defaultDisposIds) ->
    for key, i in defaultDisposIds
      $('.campaign-dispositions[value="' + key + '"]')[0].checked = true
      $('.campaign-dispositions[value="' + key + '"]')[0].setAttribute("checked", "checked")

  hideModal: ->
    $("#reset-dispositions-modal").modal('hide')  

call_queues =
  init: ->
    do @hideNewFormOnLoad
    do @showNewCallQueueForm
    do @createCallQueue

  hideNewFormOnLoad: ->
    if $('#call_queues') && $('#call_queues').length > 0
      if $('#call_queues')[0].children && $('#call_queues')[0].children.length > 0
        $('#new-call-queue-form').on('load').hide();
      else
        $('#show-new-call-queue-form')[0].innerText = "Cancel Creating New Call Queue";

  showNewCallQueueForm: ->
    $('#show-new-call-queue-form').click (event) ->
      event.preventDefault();
      call_queues.setUpNameBlank();

      if $('#new-call-queue-form')[0].style.display == "none"
        $('#new-call-queue-form').show "slow"
        $('#show-new-call-queue-form')[0].innerText = "Cancel Creating New Call Queue";
      else
        $('#new-call-queue-form').on('load').hide();
        $('#show-new-call-queue-form')[0].innerText = "Create New Call Queue";

  createCallQueue: ->
    $('.create_call_queue').click (event) ->
      event.preventDefault();
      call_queue_name = $('#call_queue_call_queue_name')[0].value;
      language_id = $('#call_queue_language_id')[0].value;
      dealer_id = $('#dealer_id')[0].value;
      twilio_number_id = $('#twilio_number_id')[0].value;

      if !call_queue_name
        $.gritter.add
          title: "<i class=\"fa fa-warning\"></i> Notice",
          text: "Please enter a call queue name.",
          sticky: false,
          time: "", 
          class_name: "gritter-notice"

      if !language_id
        $.gritter.add
          title: "<i class=\"fa fa-warning\"></i> Notice",
          text: "Please select a language.",
          sticky: false,
          time: "", 
          class_name: "gritter-notice"

      if call_queue_name && call_queue_name.length > 0 && language_id && parseInt(language_id, 10) > 0
        $.ajax(
          type: 'post',
          url: '/campaigns/create_call_queue/',
          data:
            call_queue_name: call_queue_name,
            language_id: language_id,
            dealer_id: dealer_id,
            twilio_number_id: twilio_number_id
        ).done (data) ->
          unless data.errors
            call_queues.appendCallQueue(data.call_queue.call_queue_name, data.call_queue.id)
            $('#new-call-queue-form').on('load').hide();
            $('#show-new-call-queue-form')[0].innerText = "Create New Call Queue";
            call_queues.setUpNameBlank();
          else
            if data.error_message.call_queue_name && !data.error_message.twilio_number_id
              $.gritter.add
                title: "<i class=\"fa fa-warning\"></i> Notice",
                text: "That name has already been used with that language. Please choose another name.",
                sticky: false,
                time: "", 
                class_name: "gritter-notice"
            else if data.error_message.twilio_number_id && !data.error_message.call_queue_name
              $.gritter.add
                title: "<i class=\"fa fa-warning\"></i> Notice",
                text: "Numbers must be unique to language.  Please select a different language.",
                sticky: false,
                time: "", 
                class_name: "gritter-notice"
            else
              $.gritter.add
                title: "<i class=\"fa fa-warning\"></i> Notice",
                text: "That name has already been used with that language. Please choose another name. Also, numbers must be unique to language.  Please select a different language.",
                sticky: false,
                time: "", 
                class_name: "gritter-notice"

  setUpNameBlank: ->
    if $('#campaign_name') && $('#campaign_name').length > 0 && $('#call_queue_call_queue_name') && $('#call_queue_call_queue_name').length > 0
      $('#call_queue_call_queue_name')[0].value = $('#campaign_name')[0].value;                

  appendCallQueue: (call_queue_name, call_queue_id) ->
    $('#call_queues').append('<tr><td>' + call_queue_name + '</td><td><a href="/call_queues/' + call_queue_id + '/edit" target="_blank">Advanced Settings</td><td><a data-confirm="Are you sure?" data-method="delete" href="/call_queues/' + call_queue_id + '" ref="nofollow">Destroy</td></tr>');

survey_templates =
  init: ->
    do @showTemplateForm
    do @showQuestionOptions
    do @createTemplate
    do @createQuestionAndOptions
    do @showInProgressPreview

  showTemplateForm: ->
    $('#campaign_survey_template_id').change ->

      if $('.chosen-single')[0].children[0].innerHTML == "Create a New Survey Template"
        $("#show-survey-template").on('load').hide()
        $("#new-survey-template-form").show "slow"

        $('#creating-survey-template').show "slow"
        $('#creating-survey-template-questions').on('load').hide()

        $("#new-question-form").on('load').hide()

      else if $('.chosen-single')[0].children[0].innerHTML == "Select an Option"
        survey_templates.hideForms(); 

      else if $('.chosen-single')[0].children[0].innerHTML != ("Create a New Survey Template" || "")
        survey_templates.showTemplate();

      else
        survey_templates.hideForms(); 

  showQuestionOptions: ->
    $('#survey_template_question_survey_template_question_type_id').change ->

      if $('.question-options.active') && $('.question-options.active').length > 0
        $('.question-options.active')[0].className = "hide question-options"

      question_type = $('#survey_template_question_survey_template_question_type_id_chosen .chosen-single')[0].innerText;

      question_type = question_type.trim();

      if question_type == "Rating (numeric 1 - 10)"
        $('#question-options-form .controls .text')[0].value = "Please rate: 1 2 3 4 5 6 7 8 9 10"
        $('#question-options-form')[0].className = "question-options active";
      else if question_type == "Multiple Choice"
        $('#question-options-multiple-choice-form')[0].className = "question-options active";
      else if question_type == "Rating (numeric 1 - 5)"
        $('#question-options-form .controls .text')[0].value = "Please rate: 1 2 3 4 5"
        $('#question-options-form')[0].className = "question-options active";
      else if question_type == "True / False"
        $('#question-options-true-false-form .controls .text')[0].value = "True"
        $('#question-options-true-false-form .controls .text')[1].value = "False"
        $('#question-options-true-false-form')[0].className = "question-options active";
      else
        $('#question-options-form .controls .text')[0].value = ""
        if $('#survey_template_question_survey_template_question_type_id_chosen .chosen-single')[0].innerText.trim() != "Select an Option"
          $('#question-options-form')[0].className = "question-options active";

  appendSurveyTemplateQuestion: (question, options, id, has_next) ->
    $('.table.table-hover').append("<thead><tr><th><h5>" + question + "</h5></th></tr></thead>")

    if options && options.length > 0
      i = 1

      $('.table.table-hover').append('<tbody class="option-body" id="' + id + '"></tbody>')
      for element in options
        $('.table.table-hover #' + id + '.option-body').append("<tr><th><h6>" + i + ". " + element + "</h6></th></tr>");
        i += 1

    if has_next && has_next == true
      $('.table.table-hover').append("<tbody><tr><td></td></tr></tbody>")

  createTemplate: ->
    $('#create-template').click (event) ->
      event.preventDefault();
      campaignId = $('#survey_template_campaign_id')[0].value;
      surveyTemplateName = $('#survey_template_survey_template_name')[0].value;

      if campaignId && parseInt(campaignId, 10) && surveyTemplateName && surveyTemplateName.length > 0
        $.ajax(
          type: 'post',
          url: '/campaigns/create_survey_template/',
          data:
            campaign_id: campaignId,
            survey_template_name: surveyTemplateName
        ).done (data) ->
          if data.errors == false
            survey_templates.clearForm();
            $('#new-survey-template-form .panel-heading')[0].innerText = "Creating New Survey Template - " + data.survey_template.survey_template_name;
            survey_templates.addTemplateToChosenSelect(data.survey_template.survey_template_name, data.survey_template.id)
            
            $('#creating-survey-template').on('load').hide()

            $('.active [href="#survey_templates"]')[0].innerHTML = '<i class="fa fa-comment"></i> Question/Option(s)';
            $('#creating-survey-template-questions').show "slow"
            $('#new-survey-template-form .clearfix .left .hide')[0].className = "";
            
            $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "Survey template was successfully created. You must create at least ONE survey question in order to fulfill the question requirement to begin your campaign.",
              sticky: false,
              time: "", 
              class_name: "gritter-notice"
          else
            $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "The survey template name entered is already in use by another survey template. Please enter a different name.",
              sticky: false,
              time: "", 
              class_name: "gritter-notice"

  getQuestionParams: ->
    questionParams = {}
    for key, i in $('.survey_template_question_params')
      questionParams[$('.survey_template_question_params')[i].name.split("[")[1].split("]")[0]] = $('.survey_template_question_params')[i].value;

    questionParams["question_order"] = $('#new_survey_template_question .form-inputs')[0].id;
    questionParams["survey_template_id"] = $('.form-control.input-sm.chosen-select#campaign_survey_template_id')[0].value;
    return questionParams;

  getOptionParams: ->
    optionParams = {}
    for key, i in $('.survey_template_question_option_params')
      optionParams[i] = $('.survey_template_question_option_params')[i].value;
    return optionParams;

  createQuestionAndOptions: ->
    $('.create-question').click (event) ->
      event.preventDefault();

      buttonId = this.id;
      questionParams = survey_templates.getQuestionParams();
      optionParams = survey_templates.getOptionParams();

      $.ajax(
        type: 'post',
        url: '/campaigns/create_survey_template_question/',
        data:
          button_id: buttonId,
          survey_template_question: questionParams,
          survey_template_question_options: optionParams
      ).done (data) ->
        if data.errors == false
          question_order = parseInt($('#new_survey_template_question .form-inputs')[0].id, 10) + 1;
          $('#new_survey_template_question .form-inputs')[0].id = question_order;

          survey_templates.clearForm();
          $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "Survey template question was successfully created.",
              sticky: false,
              time: "", 
              class_name: "gritter-notice"

          if data.button_id == "create-question"
            $('#creating-survey-template-questions').on('load').hide();
            $('#creating-survey-template-questions').show "slow";
          else
            $.gritter.add
                title: "<i class=\"fa fa-warning\"></i> Notice",
                text: "Survey template was successfully saved.",
                sticky: false,
                time: "", 
                class_name: "gritter-notice"          
            survey_templates.showTemplate();
        else if data.button_id == "finish-template"
          $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "Survey template was successfully saved.",
              sticky: false,
              time: "", 
              class_name: "gritter-notice"

          survey_templates.showTemplate();
        else
          $.gritter.add
            title: "<i class=\"fa fa-warning\"></i> Notice",
            text: "Please enter some question text.",
            sticky: false,
            time: "", 
            class_name: "gritter-notice"

  clearForm: ->
    $('#survey_template_survey_template_name')[0].value = "";

    for key, i in $('.survey_template_question_params')
      $('.survey_template_question_params')[i].value = "";

    for key, i in $('.survey_template_question_option_params')
      $('.survey_template_question_option_params')[i].value = "";

    if $('.question-options.active') && $('.question-options.active').length > 0
      $('.question-options.active')[0].className = "hide question-options"      

    $("select").trigger("chosen:updated");

  addTemplateToChosenSelect: (survey_template_name, survey_template_id) ->
    $('.form-control.input-sm.chosen-select#campaign_survey_template_id').append(
      '<option selected="selected" value="' + survey_template_id + '">' + survey_template_name + '</option>');
    $("select").trigger("chosen:updated");

  showTemplate: ->
    $("#new-survey-template-form").on('load').hide()
    $("#show-survey-template").on('load').hide()
    survey_template_id = $('#campaign_survey_template_id')[0].value;

    # if the survey_template_id isn't an integer, don't try and display the questions
    if !(parseInt(survey_template_id))
      $("#new-survey-template-form").hide()
      $("#show-survey-template").hide()
      $("#edit_survey_template_div").hide()
    else
      if survey_template_id > 0
        # show the template edit button
        $("#edit_survey_template_div").show()

        # and replace with the proper URL
        $("#edit_survey_template_div #edit_template_button")[0].href = "/survey_templates/" + survey_template_id + "/edit"
        $("#edit_survey_template_div #edit_template_button")[0].setAttribute("target", "_blank")
      $.ajax(
        type: 'post',
        url: '/campaigns/get_survey_template_information/',
        data:
          survey_template_id: survey_template_id
      ).done (data) ->
        if data.errors == false
          $('#show-survey-template .panel-heading')[0].innerHTML = "<h5>" + data.survey_template.survey_template_name + "</h5>"

          $('.table.table-hover').children().remove()

          if data.survey_template_questions
            id = 1
            total_questions = Object.keys(data.survey_template_questions).length;
            if total_questions > 0
              for key, value of data.survey_template_questions
                if id < total_questions
                  has_next = true
                else
                  has_next = false
                survey_templates.appendSurveyTemplateQuestion(key, value, id, has_next)
                id += 1
            else
              $('.table.table-hover').append("<thead><tr><th><h5>There are currently no questions with this survey template.</h5></th></tr></thead>")
          else
            $('.table.table-hover').append("<thead><tr><th><h5>There are currently no questions with this survey template.</h5></th></tr></thead>")

        $("#show-survey-template").show "slow"

  showInProgressPreview: ->
    $('#new-survey-template-form .clearfix .left [href="#survey_template_question_options"]').click (event) ->
      event.preventDefault();

      survey_template_id = $('#campaign_survey_template_id')[0].value;
      $.ajax(
        type: 'post',
        url: '/campaigns/get_survey_template_information/',
        data:
          survey_template_id: survey_template_id
      ).done (data) ->
        if data.errors == false
          $('#survey_template_question_options .panel-heading')[0].innerHTML = "<h5>" + data.survey_template.survey_template_name + "</h5>"

          $('.table.table-hover').children().remove()
          id = 1
          for key, value of data.survey_template_questions
            if id < Object.keys(data.survey_template_questions).length
              has_next = true
            else
              has_next = false
            survey_templates.appendSurveyTemplateQuestion(key, value, id, has_next)
            id += 1

  hideForms: ->
    $("#show-survey-template").on('load').hide()
    $("#new-survey-template-form").on('load').hide()

whisper_recordings =
  init: ->
    do @showWhisperForm
    do @newRecording

  showWhisperForm: ->
    $('#campaign_whisper_recording').change ->
      if $('#whisper_selector .chosen-single.chosen-single-with-deselect')[0].children[0].innerHTML == "Record New Whisper"
        $("#new-whisper-recording").show "slow"
      else
        $("#new-whisper-recording").on('load').hide()

  newRecording: ->
    $('#dial-whisper-recording').click (event) ->
      event.preventDefault();
      recording_friendly_name = $('#recording_friendly_name')[0].value;
      recording_dial_number = $('#recording_dial_number')[0].value;
      user_id = $('#recording_user')[0].value;

      if recording_friendly_name.length == 0
        gritterAdd("Please enter a friendly name.")

      if recording_dial_number.length != 10
        gritterAdd("Dial number must be 10 digits.")

      else
        ajaxLoader("body")
        $.ajax(
          type: 'post',
          url: '/recordings',
          data:
            recording:
              user_id: user_id
              friendly_name: recording_friendly_name
              dial_number: recording_dial_number
        ).done (data) ->
          $(".ajax_overlay").first().fadeOut()
          if data && data.id > 0
            whisper_recordings.addRecordingToChosenSelect(data.friendly_name, data.id)
            $("#new-whisper-recording").on('load').hide()
          else
            $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "Whisper could not be created, please try again.",
              sticky: false,
              time: "",
              class_name: "gritter-notice"

  addRecordingToChosenSelect: (friendly_name, recording_id) ->
    $('.form-control.input-sm.chosen-select#campaign_whisper_recording').append(
      '<option selected="selected" value="' + recording_id + '">' + friendly_name + '</option>');
    $("select").trigger("chosen:updated");

twilio_numbers =
  init: ->
    do @showForm
    do @purchaseNumber

  showForm: ->
    $('#campaign_twilio_number_id').change ->
      if $('#twilio_number_selector .chosen-single.chosen-single-with-deselect')[0].children[0].innerHTML == "Purchase New Number"
        $("#new-twilio-number-form").show "slow"
      else
        $("#new-twilio-number-form").on('load').hide()

  purchaseNumber: ->
    $('#purchase-twilio-numbers').click (event) ->
      event.preventDefault();
      number_type = $('#twilio_number_number_type_chosen .chosen-single')[0].innerText.trim();
      area_code = $('#twilio_number_area_code')[0].value;

      if number_type == "Select an Option"
        gritterAdd("Please Select a Number Type.")

      else if area_code.length != 3
        gritterAdd("Area code must be 3 numbers long.")

      else if area_code.length == 3 && ( parseInt(area_code[0] % 1 != 0, 10) || parseInt(area_code[1], 10) % 1 != 0 || parseInt(area_code[2], 10) % 1 != 0 )
        gritterAdd("The Area Code must consist of only numbers.")

      else if number_type == "Toll Free" && (parseInt(area_code[0], 10) == 1 || parseInt(area_code[0], 10) == 0)
        gritterAdd("Toll Free Numbers cannot begin with 0 or 1. Please enter a different area code.")

      else
        ajaxLoader("body")
        $.ajax(
          type: 'post',
          url: '/twilio_numbers/auto_provision/',
          data:
            number_type: number_type,
            area_code: area_code
        ).done (data) ->
          $(".ajax_overlay").first().fadeOut()
          if data && data.id > 0
            twilio_numbers.addNumberToChosenSelect(data.phone_number, data.id)
            $("#new-twilio-number-form").on('load').hide()
          else
            $.gritter.add
              title: "<i class=\"fa fa-warning\"></i> Notice",
              text: "No numbers found for that area code. Please try a different area code.",
              sticky: false,
              time: "", 
              class_name: "gritter-notice"

  addNumberToChosenSelect: (phone_number, phone_number_id) ->
    $('.form-control.input-sm.chosen-select#campaign_twilio_number_id').append(
      '<option selected="selected" value="' + phone_number_id + '">' + phone_number + '</option>');
    $("select").trigger("chosen:updated");
                             

campaigns =
  init: ->
    do @submitRecords
    do @selectRecurType
    do @deleteRecords
    do @runCampaign
    do @changeSurveyAlertCustomer
    do @setIncludedCheck

  changeSurveyAlertCustomer: ->
    $("#campaign-survey-alerts").on "change" , "input.survey-alerts" , (event) ->
      $checkbox_val = $(@)
      $attr = $checkbox_val.attr('name').split('_')
      $alert_value = if $checkbox_val.prop("checked") then 1 else 0
      $.ajax(
        type: "post"
        url: "/change_survey_alert.json"
        data:
          alert_id: $attr[3]
          alert_type: $attr[4]
          alert_value: $alert_value
        dataType: "json"
      )

  setRowIcon: (row, id) ->
    the_div = row.children[0]
    div_id = the_div.getAttribute("id").replace(/[0-9]/g, '')
    the_div.setAttribute("id", id + div_id)

  resetDefault: (form) ->
    form_id = form.getAttribute("id")
    campaigns.setRowIcon(form.parentNode.parentNode.children[0], '')
    if form.elements["criterion-id"] then form.elements["criterion-id"].value = ''
    if form.elements["criterion-operand"] then form.elements["criterion-operand"].value = ''
    if form.elements["criterion-days"] then form.elements["criterion-days"].value = ''
    if form.elements["criterion-labor-types"] then form.elements["criterion-labor-types"].value = ''
    if form.elements["criterion-query"].classList.contains('chosen-select')
      form.elements["criterion-query"].value = ''
    if form.elements["criterion-operation-codes"] then form.elements["criterion-operation-codes"].value = ''
    if form.elements["criterion-postal-codes"] then form.elements["criterion-postal-codes"].value = ''
    if form.elements["criterion-vehicle-years"] then form.elements["criterion-vehicle-years"].value = ''
    if form.elements["criterion-vehicle-makes"] then form.elements["criterion-vehicle-makes"].value = ''
    if form.elements["criterion-vehicle-models"] then form.elements["criterion-vehicle-models"].value = ''
    if form.elements["criterion-starts-with"] then form.elements["criterion-starts-with"].value = ''
    if form.elements["criterion-contains"] then form.elements["criterion-contains"].value = ''

    if form.elements["criterion-between-lower"] then form.elements["criterion-between-lower"].value = ''
    if form.elements["criterion-between-higher"] then form.elements["criterion-between-higher"].value = ''
    if $("#" + form_id + " select") then $("#" + form_id + " select").val('').trigger("chosen:updated");

  setFormValues: (form, result) ->
    form_id = form.getAttribute("id")
    if result.criterion
      campaigns.setRowIcon(form.parentNode.parentNode.children[0], result.criterion.id)
      if result.criterion.id then form.elements["criterion-id"].value = result.criterion.id
      if result.criterion.query then form.elements["criterion-query"].value = result.criterion.query
      if result.criterion.operand then form.elements["criterion-operand"].value = result.criterion.operand
      if result.criterion.days then form.elements["criterion-days"].value = result.criterion.days
      if result.criterion.labor_types then form.elements["criterion-labor-types"].value = result.criterion.labor_types
      if result.criterion.between_lower then form.elements["criterion-between-lower"].value = result.criterion.between_lower
      if result.criterion.between_higher then form.elements["criterion-between-higher"].value = result.criterion.between_higher
      if result.criterion.operation_codes then form.elements["criterion-operation-codes"].value = result.criterion.operation_codes
      if result.criterion.postal_codes then form.elements["criterion-postal-codes"].value = result.criterion.postal_codes
      if result.criterion.vehicle_years then form.elements["criterion-vehicle-years"].value = result.criterion.vehicle_years
      if result.criterion.vehicle_makes then form.elements["criterion-vehicle-makes"].value = result.criterion.vehicle_makes
      if result.criterion.vehicle_models then form.elements["criterion-vehicle-models"].value = result.criterion.vehicle_models
      if result.criterion.starts_with then form.elements["criterion-starts-with"].value = result.criterion.starts_with
      if result.criterion.contains then form.elements["criterion-contains"].value = result.criterion.contains

      form.parentElement.parentElement.className = ''
      $("#" + form_id + " select").trigger("chosen:updated");
    else
      campaigns.resetDefault(form)

  setIncludedCheck: ->
    $('.criterion-included').hide()
    for key, i in $('.criterion-included')
      div_id = $('.criterion-included')[i].getAttribute("id")
      if parseInt(div_id.split("_")[0])
        $('#' + div_id).show()
      else
        $('#' + div_id).hide()

  deleteRecordsSuccess: (result) ->
    campaigns.setFormValues(this.form, result)
    campaigns.setIncludedCheck()
    $(this).hide()
    $(".ajax_overlay").first().fadeOut()

  deleteRecords: ->
    $(document).on "click" , ".disable-criterion" , (event) ->
      event.preventDefault()
      the_form = this.form
      criterion_id = the_form.elements["criterion-id"].value
      if parseInt(criterion_id)
        ajaxLoader("body")
        ajaxRequest = $.ajax
          type: "delete",
          url: "/criterion/" + criterion_id,
        ajaxRequest.done(campaigns.deleteRecordsSuccess.bind(this))

  gritterAdd: (title) ->
    $.gritter.add
      title: "<i class=\"fa fa-warning\"></i> Notice",
      text: "#{title}",
      sticky: false,
      time: "", 
      class_name: "gritter-notice"

  intCheck: (formsToCheck) ->
    flag = false

    for key, i in formsToCheck
      if key.value && key.value != ''
        days = parseInt(key.value, 10)
        if days % 1 != 0 || !(days > 0)
          flag = true
      else
        flag = true

    if flag then false else true

  queryCheck: (formsToCheck) ->
    flag = false

    for key, i in formsToCheck
      if !(key.value && key.value.length > 0)
        flag = true

    if flag then false else true

  multipleCheck: (formsToCheck) ->
    flag = false
    
    for key, i in formsToCheck
      if formsToCheck.chosen().val() == null
        flag = true

    if flag then false else true

  checkAll: (the_form) ->
    flag = false

    if jQuery(the_form).find(".int_check").length > 0 && campaigns.intCheck(jQuery(the_form).find(".int_check")) == false
      the_form.parentElement.parentElement.className = 'alert-danger'
      gritterAdd("Days must be greater than 0!")
      flag = true

    if jQuery(the_form).find(".query").length > 0 && campaigns.queryCheck(jQuery(the_form).find(".query")) == false
      the_form.parentElement.parentElement.className = 'alert-danger'
      gritterAdd("You have not selected an option for the query. Please select one!")
      flag = true

    if jQuery(the_form).find(".multiple").length > 0 && campaigns.multipleCheck(jQuery(the_form).find(".multiple")) == false
      the_form.parentElement.parentElement.className = 'alert-danger'
      gritterAdd("You have not selected any options for the multiple query. Please select some options.")
      flag = true

    if flag then false else true

  submitRecordsSuccess: (result) ->
    campaigns.setFormValues(this.form, result)
    campaigns.setIncludedCheck()
    $(this.parentElement.children[1]).show()
    $(".ajax_overlay").first().fadeOut()

  submitRecords: ->
    $(document).on "click" , ".submit-criterion" , (event) ->
      event.preventDefault()
      the_form = this.form
      form_id = the_form.getAttribute("id")

      if campaigns.checkAll(the_form) == true
        ajaxLoader("body")
        if the_form.elements["campaign-id"] then campaign_id = the_form.elements["campaign-id"].value else campaign_id = 0
        if the_form.elements["criterion-id"] then criterion_id = the_form.elements["criterion-id"].value else criterion_id = null
        if the_form.elements["criterion-query"] then query = the_form.elements["criterion-query"].value else query = null
        if the_form.elements["criterion-type"] then type = the_form.elements["criterion-type"].value else type = null
        if the_form.elements["criterion-operand"] then operand = the_form.elements["criterion-operand"].value  else operand = null
        if the_form.elements["criterion-days"] then days = the_form.elements["criterion-days"].value else days = null
        if $("#" + form_id + " #service-labor-types") then labor_types = $("#" + form_id + " #service-labor-types").chosen().val() else labor_types = null
        if the_form.elements["criterion-between-lower"] then between_lower = the_form.elements["criterion-between-lower"].value else between_lower = null
        if the_form.elements["criterion-between-higher"] then between_higher = the_form.elements["criterion-between-higher"].value else between_higher = null
        if $("#" + form_id + " #service-operation-codes") then operation_codes = $("#" + form_id + " #service-operation-codes").chosen().val() else operation_codes = null
        if $("#" + form_id + " #criterion-postal-codes") then postal_codes = $("#" + form_id + " #criterion-postal-codes").chosen().val() else postal_codes = null
        if $("#" + form_id + " #criterion-vehicle-years") then vehicle_years = $("#" + form_id + " #criterion-vehicle-years").chosen().val() else vehicle_years = null
        if $("#" + form_id + " #criterion-vehicle-makes") then vehicle_makes = $("#" + form_id + " #criterion-vehicle-makes").chosen().val() else vehicle_makes = null
        if $("#" + form_id + " #criterion-vehicle-models") then vehicle_models = $("#" + form_id + " #criterion-vehicle-models").chosen().val() else vehicle_models = null
        if the_form.elements["criterion-starts-with"] then starts_with = the_form.elements["criterion-starts-with"].value else starts_with = null
        if the_form.elements["criterion-contains"] then contains = the_form.elements["criterion-contains"].value else contains = null

        ajaxRequest = $.ajax
          type: "post",
          url: "/criterion/search",
          data:
            campaign_id: campaign_id
            id: criterion_id
            query: query
            criterion_type_id: type
            operand: operand
            days: days
            labor_types: labor_types
            between_lower: between_lower
            between_higher: between_higher
            operation_codes: operation_codes
            postal_codes: postal_codes
            vehicle_years: vehicle_years
            vehicle_makes: vehicle_makes
            vehicle_models: vehicle_models
            starts_with: starts_with
            contains: contains

        ajaxRequest.done(campaigns.submitRecordsSuccess.bind(this))

  runCampaign: ->
    $(document).on "click" , ".run-campaign" , (event) ->
      campaign_id = $("input#campaign_id").val()
      event.preventDefault()
      $.ajax(
        type: "post"
        url: "/start_campaign.json"
        data:
          campaign_id: campaign_id
        dataType: "json"
      ).done (data) ->
        if data.errors
          $("#error_modal .modal-body p").html(data.errors);
          $("#error_modal").modal("show").removeClass('hide');
        else
          window.location = data.campaign_path

  selectRecurType: ->
    $("body").on "change" , "#campaign_recurring_type" , (event) ->
      $rec_days= $('.recurring-days')
      if $(@).val() is '1'
        $rec_days.show()
      else
        $rec_days.hide()

window.ajaxLoader = (el, options) ->

  # Becomes this.options
  defaults =
    bgColor: "#fff"
    duration: 800
    opacity: 0.7
    classOveride: false

  @options = jQuery.extend(defaults, options)
  @container = $(el)
  @init = ->
    container = @container

    # Delete any other loaders
    @remove()

    # Create the overlay
    overlay = $("<div></div>").css(
      "background-color": @options.bgColor
      opacity: @options.opacity
      width: container.width()
      height: container.height()
      position: "absolute"
      top: "0px"
      left: "0px"
      "z-index": 99999
    ).addClass("ajax_overlay")

    # add an overiding class name to set new loader style
    overlay.addClass @options.classOveride  if @options.classOveride

    # insert overlay and loader into DOM
    container.append overlay.append($("<div></div>").addClass("ajax_loader")).fadeIn(@options.duration)

  @remove = ->
    overlay = @container.children(".ajax_overlay")
    if overlay.length
      overlay.fadeOut @options.classOveride, ->
        overlay.remove()

  @init()

$(document).ready -> 
  do campaigns.init
  do dispos_cats.init
  do voice_mails.init
  do reset_dispos.init
  do campaign_groups.init
  do twilio_numbers.init
  do call_queues.init
  do whisper_recordings.init
  do disposition_price_update.init

  $("#new-twilio-number-form").on('load').hide()
  do survey_templates.init
  $("#new-survey-template-form").on('load').hide()
  $("#new-whisper-recording").on('load').hide()

  if $('#campaign_survey_template_id')[0] && $('#campaign_survey_template_id')[0].value && $('#campaign_survey_template_id')[0].value.length > 0
    $("#show-survey-template").show();
    $("#new-survey-template-form").on('load').hide()
  else
    $("#show-survey-template").on('load').hide()

$(document).on "click" , ".reRunCampaign" , (event) ->
  event.preventDefault()
  campaign_id = this.getAttribute('data')
  ajaxLoader("body")
  $.ajax(
    type: "post"
    url: "/re_run_campaign.json"
    data:
      campaign_id: campaign_id
    dataType: "json"
  ).done (data) ->
    if data.errors
      console.log(data.errors)
    else
      $(".ajax_overlay").first().fadeOut();
      gritterAdd(data.message)
