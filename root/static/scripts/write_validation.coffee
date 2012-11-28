$ ->
  $('#w_form').validate
    rules:
      title:
        required: true
      amount:
        required: true
        number: true
    messages:
      title:
        required: "제목을 입력해 주세요"
      amount:
        required: "금액을 입력해주세요"
        number: "숫자만 입력해 주세요"
