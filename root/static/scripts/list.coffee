$ ->
  $('#head_checkbox').click ->
    cbs = $(":checkbox")
    for cb,i in cbs
      if cbs[i].type is "checkbox"
        cbs[i].checked = $(@).is(':checked')

  $('#do_delete').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/delete/' + selected_charges

  $('#do_approval').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/approval/' + selected_charges

  $('#do_refuse').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/refuse/' + selected_charges

  $('#do_deposit').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/deposit/' + selected_charges

  $('#do_export').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/export/' + selected_charges

  $('#do_cancel').click ->
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))

    location.href = '/list/cancel/' + selected_charges

  window.prettyPrint and prettyPrint()
  $('#start_date').datepicker
    format: 'yyyy-mm-dd'

  window.prettyPrint and prettyPrint()
  $('#end_date').datepicker
    format: 'yyyy-mm-dd'
