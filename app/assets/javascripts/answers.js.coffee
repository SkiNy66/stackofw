ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answers .likes').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-' + response.likable_id + ' .likes-rating').html(response.rating) 

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    attachments = $.parseJSON(data['attachments'])
    $('.answers').append(JST["templates/answer"]({answer: answer, attachments: attachments})) 

$(document).on('ready page:load', ready)
# $(document).ready(ready) # "вешаем" функцию ready на событие document.ready
# $(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
# $(document).on('page:update', ready)