Meteor.startup ->
  Accounts.config
    sendVerificationEmail: true

  # Accounts.emailTemplates.from = 'no-reply@fleetr.eu'
  # Accounts.emailTemplates.siteName = 'Fleetr'
  # Accounts.emailTemplates.verifyEmail.subject = (user) ->
  #   'Confirm your email address to activate your Fleetr account'
  # Accounts.emailTemplates.verifyEmail.text = (user, url) ->
  #   "Click on the following link to verify your email address: #{url}"

  if Meteor.isClient
    AccountsEntry.config
      privacyUrl: '/privacy-policy'
      termsUrl: '/terms-of-use'
      homeRoute: '/sign-in'
      dashboardRoute: '/'
      emailToLower: true
      profileRoute: 'profile'
      showSignupCode: true
  if Meteor.isServer
    AccountsEntry.config
      signupCode: 's3cr3t'
      showSignupCode: true

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
    @next()
  , {except: openRoutes}

  Router.onBeforeAction ->
    @layout("open")
    @next()
  , {only: openRoutes}

  Router.configure
    layoutTemplate: 'layout'
    loadingTemplate: 'loading'

  Router.map ->

    @route 'settings',
      path: '/settings'
      template: 'configurationSettings'
      waitOn: -> [Meteor.subscribe('configurationSettings')]

    @route 'odometers',
      path: '/odometers'
      template: 'odometerCorrections'
      waitOn: -> [Meteor.subscribe('vehicles')]  

    @route 'dashboard',
      path: '/'
      template: 'dashboard'
      fastRender: true
      waitOn: -> Meteor.subscribe('vehicles')


    @route 'listAlarms',
      path: '/alarms/list'
      template: 'alarms'
      waitOn: -> [Meteor.subscribe('alarms'), Meteor.subscribe('geofenceEvents'), Meteor.subscribe('customEvents')]

    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
      waitOn: -> [Meteor.subscribe('drivers'), Meteor.subscribe('vehicles')]

    @route 'listVehicles',
      path: '/vehicles/list/:fleetName?'
      template: 'vehicles'
      data: -> fleetName: @params.fleetName
      waitOn: -> [
        Meteor.subscribe('vehicles/list')
        Meteor.subscribe('fleetsForVehicleList')
        Meteor.subscribe('drivers')
      ]

    @route 'listFleetGroups',
      path: '/fleets/groups/list'
      template: 'fleetGroups'
      waitOn: -> Meteor.subscribe('fleetGroups')

    @route 'listCustomEvents',
      path: '/custom-events/list'
      template: 'customEvents'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]

    @route 'listGeofenceEvents',
      path: '/geofence-events/list'
      template: 'geofenceEvents'
      waitOn: -> [Meteor.subscribe('geofenceEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('geofences')]

    @route 'listTyres',
      path: '/tyres/list'
      template: 'tyres'
      data: -> {pageTitle: 'Гуми'}
      waitOn: -> [Meteor.subscribe('tyres'), Meteor.subscribe('vehicles')]

    @route 'listFleets',
      path: '/fleets/list'
      template: 'fleets'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleets'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]

    @route 'mapVehicles',
      path: '/vehicles/map/:vehicleId?'
      template: 'map'
      data: -> vehicleId: @params.vehicleId
      waitOn: ->
        vehicle = Vehicles.findOne _id: @params.vehicleId
        [
          Meteor.subscribe('geofences')
          Meteor.subscribe('vehicle', {_id: @params.vehicleId})
          Meteor.subscribe('vehicles')
          Meteor.subscribe('drivers')
          Meteor.subscribe('logbook/trip', vehicle?.trip?.id)
        ]

    @route 'drilldownReport',
      path: '/reports/drilldown'

    @route 'importExpenses',
      path: '/expenses/import'
      template: 'expensesImport'
      waitOn: -> [
        Meteor.subscribe('expenses')
        Meteor.subscribe('expenseTypes')
        Meteor.subscribe('expenseGroups')
        Meteor.subscribe('vehicles/licensePlates')
      ]

    @route 'listExpenseGroups',
      path: '/expenses/groups/list'
      template: 'expenseGroups'
      waitOn: -> Meteor.subscribe('expenseGroups')

    @route 'listExpenseTypes',
      path: '/expenses/types/list'
      template: 'expenseTypes'
      waitOn: -> Meteor.subscribe('expenseTypes')

    @route 'listExpenses',
      path: '/expenses/list'
      template: 'expenses'
      waitOn: -> [Meteor.subscribe('expenses'), Meteor.subscribe('expenseTypes'), Meteor.subscribe('expenseGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]

    @route 'listDocumentTypes',
      path: '/documents/types/list'
      template: 'documentTypes'
      waitOn: -> Meteor.subscribe('documentTypes')

    @route 'listDocuments',
      path: '/drivers/:driverId/documents/list'
      template: 'documents'
      data: -> {'driverId':@params.driverId}
      waitOn: -> [Meteor.subscribe('documents', @params.driverId), Meteor.subscribe('documentTypes')]

    @route 'listMaintenances',
      path: '/vehicle/:vehicleId/maintenance/list'
      template: 'maintenances'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: ->
        [Meteor.subscribe('vehicle', _id: @params.vehicleId)
        Meteor.subscribe('vehicleMaintenances', @params.vehicleId)
        Meteor.subscribe('maintenanceTypes')]

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'
      waitOn: ->
        Meteor.subscribe('maintenanceTypes')

    @route 'listInsuranceTypes',
      path: '/insurance/types/list'
      template: 'insuranceTypes'
      waitOn: ->
        Meteor.subscribe('insuranceTypes')

    @route 'listInsurances',
      path: '/insurance/list'
      template: 'insurances'
      waitOn: ->
        [Meteor.subscribe('insurances', @params.insuranceId)
        Meteor.subscribe('vehicles')
        Meteor.subscribe('insuranceTypes')]

    @route 'listInsurancePayments',
      path: '/insurance/:insuranceId/payment/list'
      template: 'insurancePayments'
      data: -> {'insuranceId' : @params.insuranceId}
      waitOn: ->
        Meteor.subscribe('insurancePayments', @params.insurancePaymentId)

    @route 'geofences',
      path: '/geofences'
      template: 'geofences'

    @route 'listDriverVehicleAssignments',
      path: '/assignments/driver/vehicle/list'
      template: 'driverVehicleAssignments'
      waitOn: ->
        [ Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('driverVehicleAssignments')]

    @route 'resetAll',
      path: '/reset'
      template: 'dashboard'
      onRun: ->
        Meteor.call 'reset'
        @next()

    @route 'fullLogbookReport',
      path: '/reports/logbook'
      template: 'fullLogbookReport'
      waitOn: -> Meteor.subscribe('vehicle', _id: @params.vehicleId)

    @route 'vehicleLogbook',
      path: '/vehicles/:vehicleId/logbook'
      template: 'logbook2'
      data: -> 
        vehicleId: @params.vehicleId
        minTripDistance: @params.query.minTripDistance
      waitOn: -> Meteor.subscribe('vehicle', _id: @params.vehicleId)

    @route 'vehicleRests',
      path: '/vehicles/:vehicleId/rests'
      template: 'logbookRests'
      data: -> vehicleId: @params.vehicleId
      waitOn: ->
        [
          Meteor.subscribe('restsOfVehicle', @params.vehicleId)
          Meteor.subscribe('vehicle', _id: @params.vehicleId)
        ]

    @route 'vehicleHistory',
      path: '/vehicles/:vehicleId/history'
      template: 'logbook'
      waitOn: -> [
        Meteor.subscribe('vehicle', _id: @params.vehicleId)
        Meteor.subscribe('vehicle/history', @params.vehicleId)
      ]
      data: ->
        'vehicle': Vehicles.findOne {_id: @params.vehicleId},
          fields:
            unitId: 1
            name: 1

    @route 'expenseReport',
      path: '/reports/expenses'
      waitOn: ->
        [
          Meteor.subscribe('expenses')
          Meteor.subscribe('vehicles')
          Meteor.subscribe('drivers')
          Meteor.subscribe('fleets')
          Meteor.subscribe('expenseGroups')
          Meteor.subscribe('expenseTypes')
        ]

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
      waitOn: -> [ Meteor.subscribe('geofences')
                  Meteor.subscribe('drivers')
                  Meteor.subscribe('vehicle', {unitId: JSON.parse(@params.data).deviceId})]
