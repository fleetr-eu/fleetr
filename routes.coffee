Meteor.startup ->
  AccountsEntry.config
    privacyUrl: '/privacy-policy',
    termsUrl: '/terms-of-use',
    homeRoute: '/',
    dashboardRoute: '/',
    emailToLower: true,
    profileRoute: 'profile',
    showSignupCode: false

  openRoutes = [
    "notFound",
    "entrySignIn",
    "entrySignOut",
    "entrySignUp",
    "entryForgotPassword",
    "entryResetPassword"
  ]

  RouterBeforeHooks =
    openLayout: -> @router.layout("open")
    requireLogin: (pause) -> AccountsEntry.signInRequired @, pause

  Router.onBeforeAction RouterBeforeHooks.requireLogin, {except: openRoutes}
  Router.onBeforeAction RouterBeforeHooks.openLayout, {only: openRoutes}

  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'dashboard',
      path: '/'
      template: 'dashboard'

    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
    @route 'addDriver',
      path: '/drivers/add'
      template: 'driver'
    @route 'editDriver',
      path: '/drivers/edit/:driverId'
      template: 'driver'
      data: -> {'driverId' : @params.driverId}


    @route 'listVehicles',
      path: '/vehicles/list'
      template: 'vehicles'
    @route 'addVehicle',
      path: '/vehicles/add'
      template: 'vehicle'
    @route 'editVehicle',
      path: '/vehicles/edit/:vehicleId'
      template: 'vehicle'
      data: -> {'vehicleId' : @params.vehicleId}
    @route 'removeVehicle',
      path: '/location/remove/:locationId'
      template: 'map'
      onRun: ->
        Meteor.call 'removeLocation', @params.locationId

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

    @route 'listDriverVehicleAssignments',
      path: '/assignments/driver/vehicle/list'
      template: 'driverVehicleAssignments'
    @route 'addDriverVehicleAssignment',
      path: '/assignments/driver/vehicle/add'
      template: 'driverVehicleAssignment'
    @route 'editDriverVehicleAssignment',
      path: '/assignments/driver/vehicle/:driverVehicleAssignmentId'
      template: 'driverVehicleAssignment'
      data: -> {'driverVehicleAssignmentId' : @params.driverVehicleAssignmentId}

    @route 'resetAll',
      path: '/reset'
      template: 'dashboard'
      onRun: ->
        Meteor.call 'reset'

    @route 'addLoctionEx',
      path: '/location/add/:vehicle/:speed/:long/:lat'
      onRun: ->
        Meteor.call 'addLocation', {
          loc: [Number(@params.long), Number(@params.lat)],
          speed: Number(@params.speed),
          stay: 0,
          vehicleId: @params.vehicle
        }
