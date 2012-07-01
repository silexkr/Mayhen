$(document).ready(function() {
  $('#w_form').submit(function() {
    var write_id = $('#applicant');
    if ($.trim(write_id.val()) == "") {
      confirm("작성자명을 입력해 주세요.");
      write_id.focus();

      return false;
    }

    var write_title = $('#title');
    if ($.trim(write_title.val()) == "") {
      confirm ("제목을 입력해 주세요.");
      write_title.focus();

      return false;
    }

    var write_content = $('textarea#content');
    if ($.trim(write_content.val()) == "") {
      confirm ("내용을 입력해 주세요.");
      $('textarea').focus();

      return false;
    }
  });
});
