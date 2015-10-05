# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(window).load ->
    if $('#survey_template_is_active') && $('#survey_template_is_active').length > 0
  	  if $('#survey_template_is_active')[0].checked == true
  		  $('#campaign_warning')[0].click();
