$(document).ready(function() {
  $('#w_form').submit(function() {
    var write_title = $('#title');
    if ($.trim(write_title.val()) == "") {
      confirm ("제목을 입력해 주세요.");
      write_title.focus();

      return false;
    }

    var write_amount = $('#amount');
    if ($.trim(write_amount.val()) == "") {
      confirm ("금액을 적어 주세요.");
      $('textarea').focus();

      return false;
    }

    });
  });
});
