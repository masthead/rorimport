# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#quickDisposition #sub-select').on('load').hide()

  $('#quickDisposition #disposition_id').change ->
    campaign_id = $("#quickDisposition .modal-body #campaign_id").val()
    from_number = $("#quickDisposition .modal-body #from_number").val()
    to_number = $("#quickDisposition .modal-body #to_number").val()
    $.ajax
      type: 'get',
      url: GET_DISPOSITION_URL,
      data: 
        campaign_id: campaign_id,
        from_number: from_number,
        to_number: to_number,
        disposition_id: $(this).val()
      success: (result) ->
        console.log "Dispostion Ajax invoked"
        # get second selectbox
        sub_select = $('#quickDisposition #sub-select')
        second_select = $('#quickDisposition #second_select')
        second_select.empty()
        if result.hasOwnProperty("result")
          second_select.hide()
        else
          sub_select.show()
          second_select.show()
          console.log result
          result.every (element, index, array) ->
            opt = $('<option>')
            opt.attr('value', element.id)
            opt.text(element.description)
            opt.appendTo(second_select)
            return true