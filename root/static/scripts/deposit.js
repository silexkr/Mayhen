// Generated by CoffeeScript 1.4.0
(function() {

  $(function() {
    $('#head_checkobx').click(function() {
      var flag;
      flag = $(this).is(':checked');
      return $(':checkbox').each(function() {
        if (flag) {
          return $(this).attr('checked', 'checked');
        } else {
          return $(this).removeAttr('checked');
        }
      });
    });
    return $('.btn').click(function() {
      var select_id, selected_charges;
      select_id = $(this).attr("id").substring(3);
      if (select_id === 'deposit') {
        select_id = 'approval';
      }
      selected_charges = [];
      $('#charge_list tr').filter(':has(:checkbox:checked)').each(function() {
        if ($(this).attr('id') !== void 0) {
          return selected_charges.push($(this).attr('id'));
        }
      });
      return location.href = "/deposit/" + select_id + "/" + selected_charges;
    });
  });

}).call(this);