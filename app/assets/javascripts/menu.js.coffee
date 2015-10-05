$ ->
  $(".class-select div li").click ->
    dealer_id = $(this).attr('value')
    console.log dealer_id
    $(".switch-dealer").find('#dealer_id').val(dealer_id)
    $(".switch-dealer").submit()

