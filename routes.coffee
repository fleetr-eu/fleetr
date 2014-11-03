Meteor.startup ->
  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'dashboard',
      path: '/'
      template: 'dashboard'
    @route 'addDriver',
      path: '/drivers/add'
      template: 'driver'
    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'

    @route 'addVehicle',
      path: '/vehicles/add'
      template: 'vehicle'
    @route 'editVehicle',
      path: '/vehicles/edit/:vehicleId'
      template: 'vehicle'
      data: -> {'vehicleId' : @params.vehicleId}
    @route 'listVehicles',
      path: '/vehicles/list'
      template: 'vehicles'

    @route 'addFleet',
      path: '/fleets/add'
      template: 'company'
    @route 'listFleets',
      path: '/fleets/list'
      template: 'companies'
      data: -> {pageTitle: 'Автопаркове'}
    @route 'addFleet',
      path: '/fleet/add'
      template: 'fleet'
    @route 'mapFleets',
      path: '/fleets/map'
      template: 'map'

    @route 'mapVehicles',
      path: '/vehicles/map'
      template: 'map'
    @route 'mapDrivers',
      path: '/drivers/map'
      template: 'map'
    @route 'drilldownReport',
      path: '/reports/drilldown'

    @route 'addExpensesFuel',
      path: '/expenses/fuel/add'
      template: 'expensesFuel'

    @route 'listNotifications',
      path: '/notifications/list'
      template: 'notificationsList'
