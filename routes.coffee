Meteor.startup ->
  Router.configure
    layoutTemplate: 'layout'
  
  Router.map ->
    @route 'dashboard', path: '/', onBeforeAction: -> Session.set 'activeCategory', 'dashboard'
    @route 'driver', onBeforeAction: -> Session.set 'activeCategory', 'driver'
    @route 'drivers', onBeforeAction: -> Session.set 'activeCategory', 'driver'
    @route 'vehicle', onBeforeAction: -> Session.set 'activeCategory', 'vehicle'
    @route 'vehicles', onBeforeAction: -> Session.set 'activeCategory', 'vehicle'
    @route 'company', onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'companies', onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'fleet', path: '/fleet/:companyId', 
            data: -> {'companyId' : @params.companyId}, 
            onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'map'