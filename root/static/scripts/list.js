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
		console.log($(this));		
		if($(this).attr('id') !== undefined)
			selected_charges.push($(this).attr('id')) 
	});
	console.log(selected_charges);
	$.ajax({
		type: 'GET',
		url: '/list/delete/' + selected_charges
	}).done(function(msg) {
		window.location.replace('/list');
	});
});

$('#do_approval').click(function() {
  var selected_charges = [];
  $('#charge_list tr').filter(':has(:checkbox:checked)').each(function(){
    console.log($(this));
    if($(this).attr('id') !== undefined)
      selected_charges.push($(this).attr('id'))
  });
  console.log(selected_charges);
  $.ajax({
    type: 'GET',
    url: '/list/approval/' + selected_charges
  }).done(function(msg) {
    window.location.replace('/list');
  });
});
