$ ->
  refresh = ->
    now = new Date()

    $('.task.todo.on-time').each (i, e) ->
      $e = $(e)
      due_at = $e.data('due-at')
      console.log now, due_at
      if due_at && new Date(due_at) < now
        $e.removeClass('on-time').addClass('delayed')

    setTimeout refresh, 1000

  refresh()
