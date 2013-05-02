$ ->
  $('.datepicker').datepicker
    onRender: (date) ->
      return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : ''
  .on 'changeDate', (ev) ->
    checkout.hide()
  .data('datepicker')
