Meteor.startup ->
  $('html').attr  'class', 'no js'
  $('body').attr  'class', 'page-header-fixed'

Template.lb.onRendered ->
  lbd.checkSidebarImage()

Template.body.onRendered ->
  @autorun ->
    title = if t = Session.get('fleetrTitle') then " | #{t}" else ''
    document.title = "Fleetr#{title}"
