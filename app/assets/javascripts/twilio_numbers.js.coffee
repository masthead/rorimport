# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

list_item = (element) ->
  $('<li class="list-group-item"><span>' + element + '</span><span class="pull-right"><a href="/twilio_numbers_provision/?number=' + element + '" id="' + element + '" class="btn btn-info btn-xs m-bottom-sm">Buy</a></span></li>')

$ ->
  $('#number-div').on('load').hide()

  $('#search-twilio-numbers').click ->
    $('#number-div').hide()
    ajaxLoader("body")
    $.ajax
      type: 'post',
      url: '/twilio_numbers_search',
      data:
        number_type: $('#twilio_number_number_type').val()
        area_code: $("#twilio_number_area_code").val()
        contains: $("#twilio_number_contains").val()
      success: (result) ->
        $(".ajax_overlay").first().fadeOut()
        console.log "twilio number Ajax invoked"
        number_div = $('#number-div')
        number_div.show()
        number_list = $('#available-numbers')
        console.log result
        result.every (element) ->
          element = element.replace("+1", '')
          opt = list_item(element)
          opt.appendTo(number_list)
          return true

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


