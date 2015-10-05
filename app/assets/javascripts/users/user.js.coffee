delete_dealer: (id) ->
  $.ajax(
    url: ""
    , type: "DELETE"
    , data: id
  )
    
$(".remove").click( ->
  id = $(this).attr("dealer-id")
  # calling delete method
  $(this).parent().remove()
)

$(".add").click( ->
  id = $(this).attr("dealer-id")
  # calling delete method
  $(this).parent().remove()
)


