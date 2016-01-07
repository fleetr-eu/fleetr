Meteor.startup ->
  $('html').attr  'class', 'no js'
  $('body').attr  'class', 'page-header-fixed'

Template.layout.onRendered ->
  Metronic.init()
  Layout.init()
  Index.init()

Template.body.onRendered ->
  @autorun ->
    title = if t = Session.get('fleetrTitle') then " | #{t}" else ''
    document.title = "Fleetr#{title}"
