ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $('.question .likes').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#question-' + response.likable_id + ' .likes-rating').html(response.rating)
    console.log($('#question-' + response.likable_id + ' .likes-rating').html(response.rating))

  PrivatePub.subscribe '/questions', (data, channel) ->
    console.log(data)
    question = $.parseJSON(data['question'])
    $('.questions').append('<h2>' + '<a href="questions/' + question.id + '">' + question.title + '</a>' + '</h2>')
    
# $(document).ready(ready) # "вешаем" функцию ready на событие document.ready
# $(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
# $(document).on('page:update', ready)
$(document).on('ready page:load', ready)