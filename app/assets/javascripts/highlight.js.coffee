class @Highlighter
  highlight: (id) ->
    return unless id

    $container = $("#task_#{id}")
    return unless $container.length > 0

    $('html, body').animate({scrollTop: $container.offset().top - 50}, '500', 'swing')

    $container.addClass('highlighted')
    f = -> $container.removeClass('highlighted')
    setTimeout f, 800
