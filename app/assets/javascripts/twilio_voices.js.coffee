$ ->
  $('#hidestuff').click ->
    $('#soft_phone_incoming').hide()
    $('#soft_phone_outgoing').hide()
    false

$ ->
  $('#showstuff').click ->
    $('#soft_phone_incoming').show()
    $('#soft_phone_outgoing').show()
    false

$ ->
  $("#dial_customer_button").hide()
$ ->
  hide_incoming = () ->
    $('#soft_phone_incoming').hide()
  hide_outgoing = () ->
    $('#soft_phone_outgoing').hide()
  $(document).ready ->
    hide_incoming()
    hide_outgoing()
    false

incoming_call = 
  init: ->
    do @answer_incoming_call

  answer_incoming_call: ->
    $("#answer_incoming_call").click (event) ->
      event.preventDefault();
      $.ajax(
        url: '/incoming_call',
        type: 'get',
        data: 
          user_id: $('#user_id')[0].value,
          campaign_id: $('#incoming_campaign_id')[0].value,
          call_id: $('#incoming_call_id')[0].value,
          pusher_call_id: $('#pusher_call_id')[0].value
      ).done (data) ->

$(document).ready -> 
  do incoming_call.init