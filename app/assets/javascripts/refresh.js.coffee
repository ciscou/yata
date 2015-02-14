$ ->
  refresh = ->
    now = new Date()

    $('.task.on-time').each (i, e) ->
      $e = $(e)
      due_at = $e.data('due-at')
      if due_at && new Date(due_at) < now
        $e.removeClass('on-time').addClass('delayed')

    setTimeout refresh, 1000

  refresh()
