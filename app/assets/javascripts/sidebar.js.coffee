$ ->
  $sidebar = $('#sidebar')

  $sidebar.on 'show.bs.offcanvas', ->
    $sidebar.addClass('navmenu navmenu-default navmenu-fixed-right')

  $sidebar.on 'hidden.bs.offcanvas', ->
    $sidebar.removeClass('navmenu navmenu-default navmenu-fixed-right')
