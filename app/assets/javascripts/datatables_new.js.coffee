dataTable =
  init: ->
    do @initDT

  initDT: ->
    $("#dataTable_dealers").dataTable
      bProcessing: true
      bServerSide: true
      bLengthChange: false
      bInfo: false
      iDisplayLength: 100
      bStateSave: true
      sAjaxSource: $(@).data('source')
      aoColumnDefs: [
        bSortable: false
        aTargets: [4,5]
      ]

    $("#dataTable_users").dataTable
      bProcessing: true
      bServerSide: true
      bLengthChange: false
      iDisplayLength: 100
      bInfo: false
      bStateSave: true
      sAjaxSource: $(@).data('source')
      aoColumnDefs: [
        bSortable: false
        aTargets: [4,5]
      ]

$(document).ready ->
  do dataTable.init
