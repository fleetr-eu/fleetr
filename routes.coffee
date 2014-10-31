Meteor.startup ->
  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'dashboard',
      path: '/'
      template: 'dashboard'
      onBeforeAction: -> Session.set 'activeCategory', 'dashboard'
    @route 'addDriver',
      path: '/drivers/add'
      template: 'driver'
      onBeforeAction: -> Session.set 'activeCategory', 'driver'
    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
      onBeforeAction: -> Session.set 'activeCategory', 'driver'
    @route 'addVehicle',
      path: '/vehicles/add'
      template: 'vehicle'
      onBeforeAction: -> Session.set 'activeCategory', 'vehicle'
    @route 'listVehicles',
      path: '/vehicles/list'
      template: 'vehicles'
      onBeforeAction: -> Session.set 'activeCategory', 'vehicle'
    @route 'addGroup',
      path: '/groups/add'
      template: 'company'
      onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'listGroups',
      path: '/groups/list'
      template: 'companies'
      onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'addFleet',
      path: '/fleet/:companyId'
      template: 'fleet'
      onBeforeAction: -> Session.set 'activeCategory', 'fleet'
      data: -> {'companyId' : @params.companyId}
    @route 'mapFleets',
      path: '/fleets/map'
      template: 'map'
      onBeforeAction: -> Session.set 'activeCategory', 'fleet'
    @route 'mapVehicles',
      path: '/vehicles/map'
      template: 'map'
      onBeforeAction: -> Session.set 'activeCategory', 'vehicle'
    @route 'mapDrivers',
      path: '/drivers/map'
      template: 'map'
      onBeforeAction: -> Session.set 'activeCategory', 'driver'
    @route 'drilldownReport',
      path: '/reports/drilldown'
      onBeforeAction: -> Session.set 'activeCategory', 'reports'
    @route 'addExpensesFuel',
      path: '/expenses/fuel/add'
      template: 'expensesFuel'
      onBeforeAction: -> Session.set 'activeCategory', 'expenses'
