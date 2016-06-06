ready = ->
  $('.question .new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question form#new-comment').show()
  
  question_id = $('.question').data('questionId')
  # PrivatePub.subscribe "/questions/#{question_id}/comments", (data, channel) ->
  PrivatePub.subscribe "/comments", (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data['comment'])
    # $('.question .comments').append('<p>' + comment.body + '</p>')
    $('#' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + ' .comments').append('<p>' + comment.body + '</p>')

  $('.answers .new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.answers form#new-comment').show()

$(document).on('ready page:load', ready)