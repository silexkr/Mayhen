$ ->
  $('#head_checkobx').click ->
    flag = $(@).is(':checked')
    $(':checkbox').each ->
      if flag then $(@).attr('checked', 'checked')
      else $(@).removeAttr('checked')

  $('.btn').click ->
    select_id = $(@).attr("id").substring(3)

    if select_id is 'deposit' then select_id = 'approval'
    selected_charges = []

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))
    location.href = "/deposit/#{select_id}/#{selected_charges}"
