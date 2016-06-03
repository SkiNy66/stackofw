ready = ->
  $('.question .new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#new-comment').show()
  
  question_id = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/#{question_id}/comments", (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data['comment'])
    $('.question .comments').append('<p>' + comment.body + '</p>')

$(document).on('ready page:load', ready)