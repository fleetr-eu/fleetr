Meteor.startup ->
    $('html').attr  'class', 'no js'
    $('body').attr  'class', 'page-header-fixed'

Template.layout.rendered = ->
  Metronic.init()
  Layout.init()
  Index.init()
  console.log 'Metronic initialized'
