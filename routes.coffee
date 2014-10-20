Meteor.startup ->
  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'fleetr', path: '/'
    @route 'driver'
    @route 'drivers'
    @route 'vehicle'
