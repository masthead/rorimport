
$ ->
  hideFields =  -> 
    $('#survey-disposition #sub-select').hide()
    $('#survey-disposition #category').hide()
    $('#appointment_div').hide()
    $('#callback_div').hide()
    $("#customer_search_row").hide()
    $("#call_button_group").hide()
    $("#next_button_group").hide()
    $('#required-warning').hide()

  hideFields();

  if !(window.location.href.match(/incoming=true/))
    $("#survey-scripts").on('load').hide()
  else
    console.log("incoming call")
    $("#customer_search_row").show()

  $('#survey_disposition_modal').click ->
    required_fields = $('.required-field')
    for value, i in required_fields
      new_classname = required_fields[i].className.replace(/\brequired-field alert-danger\b/,'');

      required_fields[i].className = new_classname

    hideFields();
    $('#disposition_id').val("")
    $("select").trigger("chosen:updated"); 

  $('#survey-disposition #disposition_id').change ->
    campaign_id = $("#customer_campaign_id").val()
    hideFields();
    $.ajax
      type: 'get',
      url: '/surveys/getdata',
      data: 
        campaign_id: campaign_id,
        disposition_id: $(this).val()
      success: (result) ->
        console.log "Dispostion Ajax invoked"

        # get second selectbox
        sub_select = $('#survey-disposition #sub-select')
        second_select = $('#survey-disposition #second_select')
        appointment_div = $('#appointment_div')
        callback_div = $('#callback_div')
        second_select.empty()

        require_validation = result.require_validation || result[result.length - 1].require_validation

        console.log(require_validation)
        if require_validation == 'true'
          required_questions = $('.required-true');

          check = false
          for value, i in required_questions
            check = !(required_questions[i].value.length > 0 || required_questions[i].innerText.trim().length > 0)

            if check == true
              required_questions[i].className = required_questions[i].className + ' required-field alert-danger'
              $('#required-warning').show();

          if $('.required-field').length == 0
            $("#next_button_group").show()
        else if require_validation == 'false'
          $("#call_button_group").show()
          $("#next_button_group").show()
        #          we should invoke field requirements and not display get next survey until field requirements are met

        if result.hasOwnProperty("result") && result.result == 'OK'
          second_select.hide()
          appointment_div.hide()
          callback_div.hide()
        else if result.hasOwnProperty("result") && result.result == 'appointment'
          appointment_div.show()
        else if result.hasOwnProperty("result") && result.result == 'callback'
          callback_div.show()
        else
          appointment_div.hide()
          callback_div.hide()
          sub_select.show()
          console.log result
          result.every (element, index, array) ->
            opt = $('<option>')
            opt.attr('value', element.id)
            opt.text(element.description)
            opt.appendTo(second_select)
            return true

        $("select").trigger("chosen:updated"); 

$ ->
  $(window).load ->
    if document.getElementById('survey_attempt_message')
      console.log document.getElementById('survey_attempt_message').innerHTML
      $.gritter.add
        title: document.getElementById('survey_attempt_message').innerHTML
        sticky: false
        time: 10001
        class_name: "gritter-regular"
        before_open: ->
          false  if $(".gritter-item-wrapper").length is 1

    false

$ ->
  $("#call_work_button").click ->
    console.log('called work')
    $("#survey-scripts").show "slow"
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_work_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()
  $("#call_home_button").click ->
    console.log('called home')
    $("#survey-scripts").show "slow"
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_home_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()
  $("#call_cell_button").click ->
    console.log('called cell')
    $("#survey-scripts").show "slow"
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_cell_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()
    false

$ ->
  getHiddenParams =  ->
    hiddenParams = {}
    for key, i in $('.hidden_field_params')[0].children
      hiddenParams[$('.hidden_field_params')[0].children[i].id] = $('.hidden_field_params')[0].children[i].value;
    return hiddenParams

  $("#modal_call_work_button").click ->
    console.log('called modal work')
    $("#survey-scripts").show "slow"
    hiddenParams = getHiddenParams();
    $.ajax(
      type: 'post',
      url: '/create_survey_attempt',
      data:
        hidden_params: hiddenParams,
        disposition_id: $('#disposition_inputs #disposition_id')[0].value,
        second_select: $('#disposition_inputs #second_select')[0].value,
        category: $('#disposition_inputs #category #category')[0].value,
        appointment_time: $('#disposition_inputs #survey_appointment_time')[0].value,
        appointment_date: $('#disposition_inputs #survey_appointment_date')[0].value,
        survey_callback_time: $('#disposition_inputs #survey_callback_time')[0].value,
        survey_callback_date: $('#disposition_inputs #survey_callback_date')[0].value,
        survey_callback_notes: $('#disposition_inputs #survey_callback_notes')[0].value,
        call_id: $('#disposition_inputs #call_id')[0].value
    ).done (data) ->
        unless data.errors
          console.log("Survey Attempt Successfully Created");
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_work_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()

  $("#modal_call_cell_button").click ->
    console.log('called modal cell')
    $("#survey-scripts").show "slow"
    hiddenParams = getHiddenParams();
    $.ajax(
      type: 'post',
      url: '/create_survey_attempt',
      data:
        hidden_params: hiddenParams,
        disposition_id: $('#disposition_inputs #disposition_id')[0].value,
        second_select: $('#disposition_inputs #second_select')[0].value,
        category: $('#disposition_inputs #category #category')[0].value,
        appointment_time: $('#disposition_inputs #survey_appointment_time')[0].value,
        appointment_date: $('#disposition_inputs #survey_appointment_date')[0].value,
        survey_callback_time: $('#disposition_inputs #survey_callback_time')[0].value,
        survey_callback_date: $('#disposition_inputs #survey_callback_date')[0].value,
        survey_callback_notes: $('#disposition_inputs #survey_callback_notes')[0].value,
        call_id: $('#disposition_inputs #call_id')[0].value

    ).done (data) ->
      unless data.errors
        console.log("Survey Attempt Successfully Created");
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_cell_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()
  $("#modal_call_home_button").click ->
    console.log('called modal home')
    $("#survey-scripts").show "slow"
    hiddenParams = getHiddenParams();
    $.ajax(
      type: 'post',
      url: '/create_survey_attempt',
      data:
        hidden_params: hiddenParams,
        disposition_id: $('#disposition_inputs #disposition_id')[0].value,
        second_select: $('#disposition_inputs #second_select')[0].value,
        category: $('#disposition_inputs #category #category')[0].value,
        appointment_time: $('#disposition_inputs #survey_appointment_time')[0].value,
        appointment_date: $('#disposition_inputs #survey_appointment_date')[0].value,
        survey_callback_time: $('#disposition_inputs #survey_callback_time')[0].value,
        survey_callback_date: $('#disposition_inputs #survey_callback_date')[0].value,
        survey_callback_notes: $('#disposition_inputs #survey_callback_notes')[0].value,
        call_id: $('#disposition_inputs #call_id')[0].value

    ).done (data) ->
        unless data.errors
          console.log("Survey Attempt Successfully Created");
    $.ajax
      type: 'get',
      url: '/twilio_outbound',
      data:
        from_number: $("#caller_id").val(),
        to_number: $("#customer_home_phone").val(),
        called: $("#called").val(),
        direction: "outbound",
        customer_id: $("#customer_id").val(),
        campaign_id: $("#customer_campaign_id").val(),
        survey_attempt_id: $("#survey_survey_attempt_id").val(),
        campaign_customer_id: $("#survey_campaign_customer_id").val()

$ ->
  getInfoParams =  ->
    infoParams = {}
    for key, i in $('.update-info-params')
      infoParams[$('.update-info-params')[i].name.split("[")[1].split("]")[0]] = $('.update-info-params')[i].value;

    infoParams['do_not_contact_flag'] = $('#customer_do_not_contact_flag')[0].checked;
    return infoParams;
   
  $('.customer-info').click (event) ->
    event.preventDefault();
    infoParams = getInfoParams();
    console.log(infoParams)
    $.ajax(
      type: 'put',
      url: '/update_customer_info',
      data:
        customer_info: infoParams,
        customer_id: $('.customer-id')[0].value
    ).done (data) ->
        unless data.errors
          console.log("Updated.")

  $('#save_and_next_survey').click (event) ->
    $('.customer-info')[0].click();

    unless $('#customer_first_name')[0].value.length > 0
      event.preventDefault();
      unless $('#customer_first_name')[0].value.length > 0
        $('#customer_first_name')[0].className += ' alert-danger'
      $('#required-warning').show();
      $("#next_button_group").hide();
