ready = ->
  $('.new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#new-comment').show()

$(document).on('ready page:load', ready)