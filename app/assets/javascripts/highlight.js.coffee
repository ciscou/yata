$ ->
  return unless id = location.hash

  $container = $(id)
  return unless $container.length > 0

  $container.addClass('highlighted')
  f = -> $container.removeClass('highlighted')
  setTimeout f, 800
