$ ->

  $("#agent_btnSelect").click ->
    ajaxLoader("body")
    $("#selectedBox1 option:selected").each ->
      call_queue = $(this)
      call_queue_id = call_queue.attr("data-id")
      updateUserCallQueue(call_queue_id, "logged_in")
      call_queue.appendTo "#selectedBox2"
      return

    $(".ajax_overlay").first().fadeOut()

    false

  $("#agent_btnRemove").click ->
    ajaxLoader("body")
    call_queue = $("#selectedBox2 option:selected").each ->
      call_queue = $(this)
      call_queue_id = call_queue.attr("data-id")
      updateUserCallQueue(call_queue_id, "logged_out")
      call_queue.appendTo "#selectedBox1"
      return

    $(".ajax_overlay").first().fadeOut()

    false

  $("#agent_btnSelectAll").click ->
    ajaxLoader("body")
    $("#selectedBox1 option").each ->
      call_queue = $(this)
      call_queue_id = call_queue.attr("data-id")
      updateUserCallQueue(call_queue_id, "logged_in")
      call_queue.appendTo "#selectedBox2"
      return

    $(".ajax_overlay").first().fadeOut()

    false

  $("#agent_btnRemoveAll").click ->
    ajaxLoader("body")
    $("#selectedBox2 option").each ->
      call_queue = $(this)
      call_queue_id = call_queue.attr("data-id")
      updateUserCallQueue(call_queue_id, "logged_out")
      call_queue.appendTo "#selectedBox1"
      return

    false

    $(".ajax_overlay").first().fadeOut()

  return

updateUserCallQueue = (call_queue_id, action) ->
  user_id = $("#user_id").val()
  url = "/agents/update_call_queue/" + call_queue_id
  $.ajax(
    type: "POST"
    url: url
    dataType: "json"
    data:
      user_action: action
      user_id: user_id
  ).success (data) ->
    console.log("Success")
  return
