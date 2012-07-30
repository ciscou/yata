class SubX
  constructor: ->

  report: (times) ->
    report = {}
    $(times).each (i, e) ->
      sub = Math.floor(e) + 1
      report[sub] ?= 0
      report[sub] += 1
    report

$ ->
  subx = new SubX

  $("form").submit (e) ->
    e.preventDefault()

    times = $("#times").val().split(/\s*,\s*/)
    times = $(times).map (i, e) -> parseFloat(e)
    report = subx.report times

    subxs = []
    subxs.push { sub: k, count: v } for k, v of report

    source   = $("#subxs-template").html()
    template = Handlebars.compile source
    $("#subxs").html template subxs: subxs
