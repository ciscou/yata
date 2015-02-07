$ ->
  $('.alert').delay(3000).slideUp ->
    $(this).remove()
