$(document).ready(function () {
  $('#head_checkbox').click(function() {
    //find all checkboxes
    var cbs = $("input:checkbox");
    //화면상의 모든 Checkbox 를 찾아서 Head Checkbox 상태와 동기화 합니다. (대장이 채크면 쫄도 모두다 채크)
    for (var i = 0; i < cbs.length; i++) {
	  if (cbs[i].type == "checkbox") {
	    cbs[i].checked = $(this).is(':checked');
	  }
    }
  });

  $('#do_delete').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/list/delete/' + selected_charges;
  });

  $('#do_approval').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/list/approval/' + selected_charges;
  });

  $('#do_refuse').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/list/refuse/' + selected_charges;
  });

  $('#do_deposit').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/deposit/approval/' + selected_charges;
  });

  $('#do_export').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/deposit/export/' + selected_charges;
  });

  $('#do_cancel').click(function() {
    var selected_charges = [];

    $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
      if($(this).attr('id') !== undefined)
        selected_charges.push($(this).attr('id'))
    });

    location.href = '/deposit//' + selected_charges;
  });

  window.prettyPrint && prettyPrint();
    $('#start_date').datepicker({
      format: 'yyyy-mm-dd'
  });
  window.prettyPrint && prettyPrint();
    $('#end_date').datepicker({
      format: 'yyyy-mm-dd'
  });
});