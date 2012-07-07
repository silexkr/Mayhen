$('#head_checkbox').click(function() {
	var cbs = $("input:checkbox"); //find all checkboxes
	//var status = $(this).var('checked');
	console.log($(this));
	 for (var i = 0; i < cbs.length; i++) {  

	    if (cbs[i].type == "checkbox") {  
	  //      cbs[i].checked = satus;
	    }  
	 }  
//	var checked = $("input[@type=checkbox]:checked"); //find all checked checkboxes + radio buttons
});