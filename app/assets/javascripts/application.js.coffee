#= require surveys
#= require campaigns.js.coffee
#= require datatables_new.js.coffee
#= require jquery.dataTables.columnFilter
#= require twilio_numbers
#= require chosen-jquery
#= require survey_template_questions.js
#= require survey_template_question_options.js
#= require surveys.js
#= require employees.js
#= require reports.js
#= require reports_for_email_append.js
#= require campaign_dispositions_add_checked.js
#= require campaigns_activatable.js
#= require conversations.js.coffee
#= require conversations_row_clickable.js
#= require messages.js
#= require survey_templates.js.coffee
#= require dealers_ajaxify.js
#= require customers.js.coffee
#= require agent_dashboards.js
#= require users_ajaxify.js
#= require agents.js.coffee
#= require ahoy

$ ->
  # enable chosen js #
  # use- input_html: { class: 'chosen-select' }
  # or if need multiple select just add option-
  # input_html: { class: 'chosen-select', multiple: true }
  $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
      width: '100%'


  alert_div = $("#alert_notification")
  if alert_div[0]
    console.log alert_div[0].innerHTML
    $.gritter.add
      title: "<i class=\"fa fa-warning\"></i> Notice"
      text: alert_div[0].innerHTML
      sticky: false
      time: ""
      class_name: "gritter-notice"

$ ->
  dealer_favorite = $(".favorite_button")
  if dealer_favorite[0]
    dealer_favorite.click ->
      $("#user_activated_dealer_id").val(this.getAttribute('data'))
      $("#dealer_chooser_submitter").click()

window.ajaxLoader = (el, options) ->

  # Becomes this.options
  defaults =
    bgColor: "#555555"
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
