$ ->
  $('#head_checkbox').click ->
    flag = $(@).is(':checked')
    $(':checkbox').each ->
      if flag then $(@).attr('checked', 'checked')
      else $(@).removeAttr('checked')

  $('.btn').click ->
    select_id = $(@).attr("id").substring(3)

    selected_charges = []
    if select_id is 'deposit' then select_id = 'approval'
    if select_id is 'refuse'  then select_id = 'refuse'
    if select_id is 'cancel'  then select_id = 'cancel'

    $('#charge_list tr').filter(':has(:checkbox:checked)').each ->
      if $(@).attr('id') isnt undefined
        selected_charges.push($(@).attr('id'))
    location.href = "/deposit/#{select_id}/#{selected_charges}"
