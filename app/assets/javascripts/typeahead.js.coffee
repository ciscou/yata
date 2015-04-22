$ ->
  $('input.typeahead').each (index, input) ->
    $input = $(input)
    $input.typeahead(source: $input.data('suggestions'))
