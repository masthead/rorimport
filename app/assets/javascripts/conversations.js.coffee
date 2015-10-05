#=require underscore

reply =
  init: ->
    do @conversationReply
    do @conversationReplyCancel
    do @createMessage

  conversationReply: ->
    $("body").on "click" , "#conversation-reply-button" , (event) ->
      event.preventDefault();
      this.parentElement.className = "clicked";
      this.parentElement.id =  this.className.split(" ", 5)[4];
      $("#conversation-reply-modal").modal("show").removeClass("hide");

  conversationReplyCancel: ->
    $("body").on "click" , "#conversation-reply-cancel" , (event) ->
      event.preventDefault();
      $('#conversation-reply-modal').modal('hide');
      reply.clearForm('#new-message-form')
      $('.clicked')[0].id = "";
      $('.clicked')[0].className = "";

  createMessage: ->
    $("#new-message-form").on "click", "button[type=\"submit\"]", (event) ->
      event.preventDefault();
      conversation_id = $('.clicked')[0].id;
      params = $(@).closest("form").serializeArray();
      input_data = {}
      $.each params, (i, e) ->
        input_data[e.name] = e.value
      $.ajax(
        type: "post"
        url: "/conversations/" + conversation_id + "/reply"
        data: input_data
      ).done (data) ->
        unless data.errors
          reply.clearForm('#new-message-form')
          $("#conversation-reply-modal").modal('hide')

  clearForm: (form) ->
    $(form).find("input[type=text], textarea").val("")
    $(form).find("input[type=checkbox]").removeAttr('checked') 
      
$(document).ready ->
  do reply.init