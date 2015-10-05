# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#=require underscore

$ ->

  hideCustomerResults =  -> 
    $('#customer-search-content').hide()
    $('#create-new-customer').hide()

  hideCustomerResults();

  getSearchParams =  ->
    searchParams = {}
    for key, i in $('.search-params')
      searchParams[$('.search-params')[i].name.split("[")[1].split("]")[0]] = $('.search-params')[i].value;
    return searchParams;

  selectCustomerBind = ->
    $('.table #customer-search-content .customer-selector').click ->

      if $('#customer_campaign_id') && $('#customer_campaign_id').length > 0
        campaign_id = $('#customer_campaign_id')[0].value;

        if this.id && parseInt(this.id, 10) > 0
          if campaign_id && parseInt(campaign_id, 10) > 0
            window.location = '/enroll_campaign_customer?campaign_id=' + campaign_id + '&customer_id=' + this.id;
          else
            window.location = '/'
      else
        dealer_id = $('#customer_dealer_id')[0].value;

        if dealer_id && parseInt(dealer_id, 10) > 0
          window.location = '/dealers/' + dealer_id + '/customers/' + this.id + '/edit'
        else
          window.location = '/'


  searchCustomerLogic = ->
    customer_search_params = getSearchParams();
    ajaxLoader("#search_results_box");
    $.ajax(
      type: 'get',
      url: '/customer_search_results',
      data: 
        customer_search_params: customer_search_params
    ).done (data) ->
      $(".ajax_overlay").first().fadeOut();
      unless data.errors
        if data && data.search_results
          $('#customer-search-content').children().remove();

          for value, i in data.search_results
            customer = data.search_results[i];
            $('#customer-search-content').append('<tr><td>' + (customer.first_name || "") + ' ' + (customer.last_name || "") + '</td><td>' + (customer.email_address_1 || "") + '</td><td>' + (customer.home_phone || "") + '</td><td>' + (customer.address_1 || "") + '</td><td><a href="#"><button  id="' + customer.id + '" class="btn-xs btn-success customer-selector">Select</button><a></td></tr>')

            selectCustomerBind();


          $('#customer-search-content').show "slow"
          $('#create-new-customer').show "slow"

  $('#new_customer').change (event) ->
    event.preventDefault();

    total_keys = $('#new_customer #customer_customer_name')[0].value.length + $('#new_customer #customer_customer_email')[0].value.length + $('#new_customer #customer_customer_phone')[0].value.length + $('#new_customer #customer_customer_address')[0].value.length;

    if total_keys >= 3
      searchCustomerLogic();
    else
      $('#customer-search-content').hide()
      $('#create-new-customer').hide()

  $('#new_customer').click (event) ->
    event.preventDefault();
    searchCustomerLogic();

$ ->
  $('#dashboard_customers a').click = (e) ->
    e.preventDefault()
    $(this).tab('show')

$ ->
  $('.btn.send-call-recording').click (event) ->
    event.preventDefault();

    call_id = this.id
    if $('.customer_id') then customer_id = $('.customer_id')[0].value else customer_id = null
    if $('#' + this.id + '[name="email_address"]') then email_address = $('#' + this.id + '[name="email_address"]')[0].value else email_address = null

    if call_id && parseInt(call_id, 10) > 0 && customer_id && parseInt(customer_id, 10) > 0 && email_address && email_address.length > 0
      $.ajax(
        type: "get"
        url: "/send_call_recording.json"
        data:
          call_id: call_id
          customer_id: customer_id
          email_address: email_address
      ).done (data) ->
        unless data.errors
          $.gritter.add
            title: "<i class=\"fa fa-warning\"></i> Notice",
            text: "Successfully emailed the call recording.",
            sticky: false,
            time: "", 
            class_name: "gritter-notice"
        else
          $.gritter.add
            title: "<i class=\"fa fa-warning\"></i> Notice",
            text: "Error. Something went wrong.",
            sticky: false,
            time: "", 
            class_name: "gritter-notice"
              