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
    loadingTemplate: 'loading'

  Router.map ->
    @route 'dashboard',
      path: '/'
      template: 'dashboard'
      fastRender: true

    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
      waitOn: -> Meteor.subscribe('drivers')
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
      waitOn: ->
        [Meteor.subscribe('vehicles')
        Meteor.subscribe('fleets')
        Meteor.subscribe('drivers')
        Meteor.subscribe('driverVehicleAssignments')]
    @route 'addVehicle',
      path: '/vehicles/add'
      template: 'vehicle'
      waitOn: ->
        [Meteor.subscribe('vehiclesMakes'), Meteor.subscribe('vehiclesModels')]
    @route 'editVehicle',
      path: '/vehicles/edit/:vehicleId'
      template: 'vehicle'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: ->
        [Meteor.subscribe('vehiclesMakes')
          Meteor.subscribe('vehiclesModels')
          Meteor.subscribe('vehicle', _id: @params.vehicleId)]
    @route 'removeVehicle',
      path: '/location/remove/:locationId'
      template: 'map'
      onRun: ->
        Meteor.call 'removeLocation', @params.locationId
        @next()

    @route 'listFleetGroups',
      path: '/fleets/groups/list'
      template: 'fleetGroups'
      data: -> {pageTitle: 'Fleet Groups'}
      waitOn: -> Meteor.subscribe 'fleetGroups'
    @route 'addFleetGroup',
      path: '/fleets/groups/add'
      template: 'fleetGroup'
    @route 'editFleetGroup',
      path: '/fleets/groups/edit/:groupId'
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
      path: '/vehicles/map/:vehicleId?'
      template: 'map'
      data: -> vehicleId: @params.vehicleId
      waitOn: ->
        Meteor.subscribe('vehicles')
    @route 'mapDrivers',
      path: '/drivers/map'
      template: 'map'
      waitOn: ->
        Meteor.subscribe('drivers')

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
      waitOn: ->
        [Meteor.subscribe('expenseTypes')
          Meteor.subscribe('expenseGroups')
          Meteor.subscribe('drivers')
          Meteor.subscribe('vehicles')]

    @route 'addMaintenanceType',
      path: '/maintenance/types/add'
      template: 'maintenanceType'

    @route 'editMaintenanceType',
      path: '/maintenance/types/edit/:maintenanceTypeId'
      template: 'maintenanceType'
      data: -> {'maintenanceTypeId' : @params.maintenanceTypeId}
      waitOn: ->
        Meteor.subscribe('maintenanceType', @params.maintenanceTypeId)

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'
      waitOn: ->
        Meteor.subscribe('maintenanceTypes')

    @route 'addMaintenance',
      path: '/vehicle/:vehicleId/maintenances/add'
      template: 'maintenance'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: ->
        [Meteor.subscribe('vehicleMaintenances', @params.vehicleId)
        Meteor.subscribe('maintenanceTypes')]

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
      waitOn: ->
        [Meteor.subscribe('vehicles')
        Meteor.subscribe('drivers')
        Meteor.subscribe('driverVehicleAssignments')]
    @route 'addDriverVehicleAssignment',
      path: '/assignments/driver/vehicle/add'
      template: 'driverVehicleAssignment'
      waitOn: ->
        [Meteor.subscribe('vehicles')
        Meteor.subscribe('drivers')]
    @route 'editDriverVehicleAssignment',
      path: '/assignments/driver/vehicle/:driverVehicleAssignmentId'
      template: 'driverVehicleAssignment'
      data: -> {'driverVehicleAssignmentId' : @params.driverVehicleAssignmentId}
      waitOn: ->
        [Meteor.subscribe('vehicles')
        Meteor.subscribe('drivers')
        Meteor.subscribe('driverVehicleAssignment', _id: @params.driverVehicleAssignmentId)]

    @route 'resetAll',
      path: '/reset'
      template: 'dashboard'
      onRun: ->
        Meteor.call 'reset'
        @next()

    @route 'logbook',
      path: '/logbook'
      template: 'logbook'
      # subscriptions: -> Meteor.subscribe 'mycodes'

    @route 'logbookStartStop',
      path: '/logbook/detailed/:selectedDate'
      template: 'logbookStartStop'
      # waitOn: -> Meteor.subscribe('mycodes')
      data: -> {'selectedDate' : @params.selectedDate}

    @route 'logbookIdle',
      path: '/logbook/idle/:selectedDate/:xxx?'
      template: 'logbookIdle'
      # waitOn: -> Meteor.subscribe('mycodes')
      data: -> {'selectedDate': @params.selectedDate, 'xxx': @params.xxx}

    @route 'reclog',
      path: '/reclog/:date?/:startTime?/:stopTime?'
      template: 'reclog'
      data: ->
        'date': @params.date
        'startTime': @params.startTime
        'stopTime': @params.stopTime

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
