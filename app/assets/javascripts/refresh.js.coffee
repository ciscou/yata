refresh = ->
  now = new Date()

  $('.task.on-time').each (i, e) ->
    $e = $(e)
    due_at = $e.data('due-at')
    if due_at && new Date(due_at) < now
      $e.removeClass('on-time').addClass('delayed')

  setTimeout refresh, 1000

handleTaskChange = (change) ->
  $("#task_#{change.id}")
    .toggleClass('done',  change.done)
    .toggleClass('todo', !change.done)

handleSubTaskChange = (change) ->
  $("#sub_task_#{change.id}")
    .toggleClass('done',  change.done)
    .toggleClass('todo', !change.done)

wait = 1

connect = ->
  sock = new SockJS("http://sockjs-demo-node.herokuapp.com/broadcast")

  sock.onopen = (e) ->
    wait = 1

  sock.onmessage = (e) ->
    data = JSON.parse(e.data)
    if data['sockjs-demo:yata:task']
      handleTaskChange JSON.parse data['sockjs-demo:yata:task']
    if data['sockjs-demo:yata:subtask']
      handleSubTaskChange JSON.parse data['sockjs-demo:yata:subtask']

  sock.onclose = (e) ->
    console?.log(body: "disconnected")
    console?.log(body: "trying to reconnect in " + wait + " seconds")
    setTimeout(connect, wait * 1000)
    wait *= 2

$ ->
  refresh()
  connect()
