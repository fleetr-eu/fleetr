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
      waitOn: -> Meteor.subscribe('drivers')
    @route 'editDriver',
      path: '/drivers/edit/:driverId'
      template: 'driver'
      data: -> {'driverId' : @params.driverId}
      waitOn: -> Meteor.subscribe('drivers')

    @route 'listVehicles',
      path: '/vehicles/list'
      template: 'vehicles'
      waitOn: -> [Meteor.subscribe('vehicles'), Meteor.subscribe('fleets'), Meteor.subscribe('drivers')]
    @route 'addVehicle',
      path: '/vehicles/add'
      template: 'vehicle'
      waitOn: -> [Meteor.subscribe('vehiclesMakes'), Meteor.subscribe('vehiclesModels'), Meteor.subscribe('fleets')]
    @route 'editVehicle',
      path: '/vehicles/edit/:vehicleId'
      template: 'vehicle'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: -> [Meteor.subscribe('vehiclesMakes'), Meteor.subscribe('vehiclesModels'), Meteor.subscribe('vehicle', _id: @params.vehicleId), Meteor.subscribe('fleets')]

    @route 'addFleetGroup',
      path: '/fleets/groups/add'
      template: 'fleetGroup'

    @route 'editFleetGroup',
      path: '/fleets/groups/edit/:fleetGroupId'
      template: 'fleetGroup'
      data: -> {'fleetGroupId' : @params.fleetGroupId}
      waitOn: -> Meteor.subscribe('fleetGroups')

    @route 'listFleetGroups',
      path: '/fleets/groups/list'
      template: 'fleetGroups'
      waitOn: -> Meteor.subscribe('fleetGroups')

    @route 'listTyres',
      path: '/tyres/list'
      template: 'tyres'
      data: -> {pageTitle: 'Гуми'}
      waitOn: -> [Meteor.subscribe('tyres'), Meteor.subscribe('vehicles')]

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

    @route 'drilldownReport',
      path: '/reports/drilldown'

    @route 'addExpenseGroup',
      path: '/expenses/groups/add'
      template: 'expenseGroup'

    @route 'editExpenseGroup',
      path: '/expenses/groups/edit/:expenseGroupId'
      template: 'expenseGroup'
      data: -> {'expenseGroupId' : @params.expenseGroupId}
      waitOn: -> Meteor.subscribe('expenseGroups')

    @route 'listExpenseGroups',
      path: '/expenses/groups/list'
      template: 'expenseGroups'
      waitOn: -> Meteor.subscribe('expenseGroups')

    @route 'addExpenseType',
      path: '/expenses/types/add'
      template: 'expenseType'

    @route 'editExpenseType',
      path: '/expenses/types/edit/:expenseTypeId'
      template: 'expenseType'
      data: -> {'expenseTypeId' : @params.expenseTypeId}
      waitOn: -> Meteor.subscribe('expenseTypes')

    @route 'listExpenseTypes',
      path: '/expenses/types/list'
      template: 'expenseTypes'
      waitOn: -> Meteor.subscribe('expenseTypes')

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
      waitOn: -> Meteor.subscribe('maintenanceType', @params.maintenanceTypeId)

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'
      waitOn: ->
        Meteor.subscribe('maintenanceTypes')

    @route 'addInsuranceType',
      path: '/insurance/types/add'
      template: 'insuranceType'

    @route 'editInsuranceType',
      path: '/insurance/types/edit/:insuranceTypeId'
      template: 'insuranceType'
      data: -> {'insuranceTypeId' : @params.insuranceTypeId}
      waitOn: -> Meteor.subscribe('insuranceType', @params.insuranceTypeId)

    @route 'listInsuranceTypes',
      path: '/insurance/types/list'
      template: 'insuranceTypes'
      waitOn: ->
        Meteor.subscribe('insuranceTypes')

    @route 'addMaintenance',
      path: '/vehicle/:vehicleId/maintenances/add'
      template: 'maintenance'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: -> [Meteor.subscribe('vehicleMaintenances', @params.vehicleId), Meteor.subscribe('maintenanceTypes')]

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
      waitOn: -> [Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('driverVehicleAssignments')]
    @route 'addDriverVehicleAssignment',
      path: '/assignments/driver/vehicle/add'
      template: 'driverVehicleAssignment'
      waitOn: -> [Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
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

    @route 'logbookReport',
      path: '/reports/logbook'
      template: 'logbook'
      # subscriptions: -> Meteor.subscribe 'mycodes'
    @route 'logbookReport2',
      path: '/reports/logbook2'
      template: 'logbook2'
      waitOn: -> Meteor.subscribe 'aggbydate'
      # subscriptions: -> Meteor.subscribe 'mycodes'

    @route 'logbookReportStartStop',
      path: '/reports/logbook/detailed/:selectedDate'
      template: 'logbookStartStop'
      # waitOn: -> Meteor.subscribe('mycodes')
      data: -> {'selectedDate' : @params.selectedDate}

    @route 'logbookReportIdle',
      path: '/reports/logbook/idle/:selectedDate/:xxx?'
      template: 'logbookIdle'
      # waitOn: -> Meteor.subscribe('mycodes')
      data: -> {'selectedDate': @params.selectedDate, 'xxx': @params.xxx}

    @route 'reclogReport',
      path: '/reports/reclog/:date?/:startTime?/:stopTime?'
      template: 'reclog'
      data: ->
        'date': @params.date
        'startTime': @params.startTime
        'stopTime': @params.stopTime

    @route 'expenseReport',
      path: '/reports/expenses'
    @route 'maintenanceReport',
      path: '/reports/maintenance'

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
