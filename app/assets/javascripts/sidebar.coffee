$ ->
  $sidebar = $('#sidebar')

  $sidebar.on 'show.bs.offcanvas', ->
    $sidebar.addClass('navmenu navmenu-default navmenu-fixed-right')
    $sidebar.removeClass('visible-md-block visible-lg-block')

  $sidebar.on 'hidden.bs.offcanvas', ->
    $sidebar.removeClass('navmenu navmenu-default navmenu-fixed-right')
    $sidebar.addClass('visible-md-block visible-lg-block')
