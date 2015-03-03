$ ->
  $('#head_checkbox').click ->
    flag = $(@).is(':checked')
    $(':checkbox').each ->
      if flag then $(@).attr('checked', 'checked')
      else $(@).removeAttr('checked')

  $('.btn').click ->
    select_id = $(@).attr("id").substring(3)
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))
    location.href = "/list/#{select_id}/#{selected_charges}"

  window.prettyPrint and prettyPrint()
  $('#start_date, #end_date').datepicker
    format: 'yyyy-mm-dd'
  $('#usage_date').datepicker
    format: 'yyyy-mm-dd'
