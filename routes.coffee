Meteor.startup ->
  Accounts.config
    sendVerificationEmail: true

  # Accounts.emailTemplates.from = 'no-reply@fleetr.eu'
  # Accounts.emailTemplates.siteName = 'Fleetr'
  # Accounts.emailTemplates.verifyEmail.subject = (user) ->
  #   'Confirm your email address to activate your Fleetr account'
  # Accounts.emailTemplates.verifyEmail.text = (user, url) ->
  #   "Click on the following link to verify your email address: #{url}"

  AccountsEntry.config
    privacyUrl: '/privacy-policy',
    termsUrl: '/terms-of-use',
    homeRoute: '/',
    dashboardRoute: '/',
    emailToLower: true,
    profileRoute: 'profile',
    showSignupCode: false
    forbidClientAccountCreation: false

  openRoutes = [
    "notFound",
    "entrySignIn",
    "entrySignOut",
    "entrySignUp",
    "entryForgotPassword",
    "entryResetPassword"
  ]

  Router.onBeforeAction ->
    AccountsEntry.signInRequired @
  , {except: openRoutes}
  Router.onBeforeAction ->
    @layout("open")
    @next()
  , {only: openRoutes}

  Router.configure
    layoutTemplate: 'layout'

  Router.map ->
    @route 'dashboard',
      path: '/'
      template: 'dashboard'
      fastRender: true

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
        @next()

    @route 'listFleetGroups',
      path: '/groups/list'
      template: 'fleetGroups'
      data: -> {pageTitle: 'Групи автопаркове'}
      waitOn: -> Meteor.subscribe 'fleetGroups'
    @route 'addFleetGroup',
      path: '/groups/add'
      template: 'fleetGroup'
    @route 'editFleetGroup',
      path: '/groups/edit/:groupId'
      template: 'fleetGroup'
      data: -> {'groupId' : @params.groupId}
      waitOn: -> Meteor.subscribe 'fleetGroup', @params.groupId

    @route 'listFleets',
      path: '/fleets/list'
      template: 'fleets'
      data: -> {pageTitle: 'Автопаркове'}
      waitOn: -> [Meteor.subscribe('fleets'), Meteor.subscribe('fleetGroups')]
    @route 'addFleet',
      path: '/fleets/add'
      template: 'fleet'
      waitOn: -> Meteor.subscribe 'fleetGroups'
    @route 'editFleet',
      path: '/fleets/edit/:fleetId'
      template: 'fleet'
      data: -> {'fleetId' : @params.fleetId}
      waitOn: -> [Meteor.subscribe('fleet', @params.fleetId), Meteor.subscribe('fleetGroups')]

    @route 'mapVehicles',
      path: '/vehicles/map'
      template: 'map'
    @route 'mapDrivers',
      path: '/drivers/map'
      template: 'map'

    @route 'drilldownReport',
      path: '/reports/drilldown'

    @route 'addExpenseGroup',
      path: '/expenses/groups/add'
      template: 'expenseGroup'

    @route 'addExpenseType',
      path: '/expenses/types/add'
      template: 'expenseType'

    @route 'addExpense',
      path: '/expenses/add'
      template: 'expense'

    @route 'addMaintenanceType',
      path: '/maintenance/types/add'
      template: 'maintenanceType'

    @route 'editMaintenanceType',
      path: '/maintenance/types/edit/:maintenanceTypeId'
      template: 'maintenanceType'
      data: -> {'maintenanceTypeId' : @params.maintenanceTypeId}

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'

    @route 'addMaintenance',
      path: '/vechile/:vehicleId/maintenances/add'
      template: 'maintenance'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: -> Meteor.subscribe('vehicleMaintenances', @params.vehicleId)

    @route 'listAlarms',
      path: '/alarms/list'
      template: 'alarmsList'

    @route 'listNotifications',
      path: '/notifications/list'
      template: 'notificationsList'

    @route 'geofences',
      path: '/geofences'
      template: 'geofences'

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
        @next()

    @route 'logbook',
      path: '/logbook'
      template: 'logbook'
      subscriptions: -> Meteor.subscribe 'mycodes'

    @route 'reclog',
      path: '/reclog'
      template: 'reclog'
      # subscriptions: -> Meteor.subscribe 'logbook'

    @route 'alarm-definitions-add',
      path: '/alarm-definitions/add'
      template: 'alarmDefinitionsAdd'
      # subscriptions: -> Meteor.subscribe 'alarm-definitions'

    @route 'alarm-definitions-list',
      path: '/alarm-definitions/list'
      template: 'alarmDefinitionsList'
      # subscriptions: -> Meteor.subscribe 'alarm-definitions'

    @route 'simple-map',
      path: '/map/:data?'
      template: 'simpleMap'
      data: -> @params?.data
