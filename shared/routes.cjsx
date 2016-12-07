React       = require 'react'
FleetsMenu  = require '/imports/ui/FleetsMenu.cjsx'
CrudButtons = require '/imports/ui/CrudButtons.cjsx'
MapAdditionalControls = require '/imports/ui/MapAdditionalControls.cjsx'
GeofencesNav          = require '/imports/ui/navs/GeofencesNav.cjsx'
VehiclesLogbookNav    = require '/imports/ui/navs/VehiclesLogbookNav.cjsx'

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
      logo: '/images/truck.png'
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

    @route '/', ->
      @redirect '/vehicles/map'

    @route 'listAlarms',
      path: '/alarms/list'
      template: 'alarms'
      waitOn: -> [Meteor.subscribe('alarms'), Meteor.subscribe('geofenceEvents'), Meteor.subscribe('customEvents')]
      data: ->
        title: TAPi18n.__('alarms.listTitle')
        topnav: <CrudButtons editItemTemplate='alarm' i18nRoot='alarms' collection=Alarms removeItemMethod='removeAlarm' />

    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
      waitOn: -> [Meteor.subscribe('drivers'), Meteor.subscribe('vehicles')]
      data: ->
        title: TAPi18n.__('drivers.listTitle')
        topnav: <CrudButtons editItemTemplate='driver' i18nRoot='drivers' collection=Drivers removeItemMethod='removeDriver' showDocumentsButton={true}/>

    @route 'listVehicles',
      path: '/vehicles/list/:fleetName?'
      template: 'vehicles'
      data: -> fleetName: @params.fleetName
      waitOn: -> [
        Meteor.subscribe('vehicles/list')
        Meteor.subscribe('fleetsForVehicleList')
        Meteor.subscribe('drivers')
      ]
      data: ->
        title: TAPi18n.__('vehicles.listTitle')
        topnav: <CrudButtons editItemTemplate='vehicle' i18nRoot='vehicles' showMaintenancesButton=true collection=Vehicles removeItemMethod='removeVehicle'/>

    @route 'listCustomEvents',
      path: '/custom-events/list'
      template: 'customEvents'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__ 'customEvents.listTitle'
        topnav: <CrudButtons editItemTemplate='customEvent' i18nRoot='customEvents' collection=CustomEvents removeItemMethod='removeCustomEvent'/>

    @route 'listGeofenceEvents',
      path: '/geofence-events/list'
      template: 'geofenceEvents'
      waitOn: -> [Meteor.subscribe('geofenceEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('geofences')]
      data: ->
        title: TAPi18n.__ 'geofenceEvents.listTitle'
        topnav: <CrudButtons editItemTemplate='geofenceEvent' i18nRoot='geofenceEvents' collection=GeofenceEvents removeItemMethod='removeGeofenceEvent'/>


    @route 'listTyres',
      path: '/tyres/list'
      template: 'tyres'
      data: -> {pageTitle: 'Гуми'}
      waitOn: -> [Meteor.subscribe('tyres'), Meteor.subscribe('vehicles')]
      data: ->
        title: TAPi18n.__('tyre.listTitle')
        topnav: <CrudButtons editItemTemplate='tyre' i18nRoot='tyre' collection=Tyres removeItemMethod='removeTyre' />


    @route 'listFleets',
      path: '/fleets/list'
      template: 'fleets'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleets'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__('fleet.listTitle')
        topnav: <CrudButtons editItemTemplate='fleet' i18nRoot='fleet' collection=Fleets removeItemMethod='removeFleet'>
          <li><a href={Router.path 'listFleets'}>Fleets</a></li>
          <li><a className='active' href={Router.path 'listFleetGroups'}>Fleet Groups</a></li>
        </CrudButtons>

    @route 'listFleetGroups',
      path: '/fleets/groups/list'
      template: 'fleetGroups'
      waitOn: -> Meteor.subscribe('fleetGroups')
      data: ->
        title: TAPi18n.__('fleetGroups.listTitle')
        topnav: <CrudButtons editItemTemplate='fleetGroup' i18nRoot='fleetGroups' collection=FleetGroups removeItemMethod='removeFleetGroup'>
          <li><a href={Router.path 'listFleets'}>Fleets</a></li>
          <li><a className='active' href={Router.path 'listFleetGroups'}>Fleet Groups</a></li>
        </CrudButtons>

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
      data: ->
        #title: 'Карта на автомобили'
        title: TAPi18n.__('map.title')
        contentClass: 'noPadding'
        topnav: <MapAdditionalControls />

    @route 'drilldownReport',
      path: '/reports/drilldown'
      data: -> title: TAPi18n.__('reports.listTitle')

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
      data: ->
        title: TAPi18n.__('expenseGroups.listTitle')
        topnav: <CrudButtons editItemTemplate='expenseGroup' i18nRoot='expenseGroups' collection=ExpenseGroups removeItemMethod='removeExpenseGroup'/>

    @route 'listExpenseTypes',
      path: '/expenses/types/list'
      template: 'expenseTypes'
      waitOn: -> Meteor.subscribe('expenseTypes')
      data: ->
        title: TAPi18n.__('expenseTypes.listTitle')
        topnav: <CrudButtons editItemTemplate='expenseType' i18nRoot='expenseTypes' collection=ExpenseTypes removeItemMethod='removeExpenseType'/>


    @route 'listExpenses',
      path: '/expenses/list'
      template: 'expenses'
      waitOn: -> [Meteor.subscribe('expenses'), Meteor.subscribe('expenseTypes'), Meteor.subscribe('expenseGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__('expenses.listTitle')
        topnav: <CrudButtons editItemTemplate='expense' i18nRoot='expenses' collection=Expenses removeItemMethod='removeExpense'/>

    @route 'listDocumentTypes',
      path: '/documents/types/list'
      template: 'documentTypes'
      waitOn: -> Meteor.subscribe('documentTypes')
      data: ->
        title: TAPi18n.__('documentTypes.listTitle')
        topnav: <CrudButtons editItemTemplate='documentType' i18nRoot='documentTypes' collection=DocumentTypes removeItemMethod='removeDocumentType'/>


    @route 'listDocuments',
      path: '/drivers/:driverId/documents/list'
      template: 'documents'
      data: -> {'driverId':@params.driverId}
      waitOn: -> [Meteor.subscribe('documents', @params.driverId), Meteor.subscribe('documentTypes')]
      data: -> title: TAPi18n.__('drivers.listTitle')

    @route 'listMaintenances',
      path: '/vehicle/:vehicleId/maintenance/list'
      template: 'maintenances'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: ->
        [Meteor.subscribe('vehicle', _id: @params.vehicleId)
        Meteor.subscribe('vehicleMaintenances', @params.vehicleId)
        Meteor.subscribe('maintenanceTypes')]
      data: -> title: TAPi18n.__('maintenances.listTitle')

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'
      waitOn: ->
        Meteor.subscribe('maintenanceTypes')
      data: ->
        title: TAPi18n.__('maintenanceTypes.listTitle')
        topnav: <CrudButtons editItemTemplate='maintenanceType' i18nRoot='maintenanceTypes' collection=MaintenanceTypes removeItemMethod='removeMaintenanceType'/>


    @route 'listInsuranceTypes',
      path: '/insurance/types/list'
      template: 'insuranceTypes'
      waitOn: ->
        Meteor.subscribe('insuranceTypes')
      data: ->
        title: TAPi18n.__('insuranceTypes.listTitle')
        topnav: <CrudButtons editItemTemplate='insuranceType' i18nRoot='insuranceTypes' collection=InsuranceTypes removeItemMethod='removeInsuranceTypes'/>

    @route 'listInsurances',
      path: '/insurance/list'
      template: 'insurances'
      waitOn: ->
        [Meteor.subscribe('insurances', @params.insuranceId)
        Meteor.subscribe('vehicles')
        Meteor.subscribe('insuranceTypes')]
      data: ->
        title: TAPi18n.__('insurances.listTitle')
        topnav: <CrudButtons editItemTemplate='insurance' i18nRoot='insurances' collection=Insurances removeItemMethod='removeInsurance'/>

    @route 'listInsurancePayments',
      path: '/insurance/:insuranceId/payment/list'
      template: 'insurancePayments'
      data: ->
        insuranceId : @params.insuranceId
        title: TAPi18n.__('insurance.listTitle')
      waitOn: ->
        Meteor.subscribe('insurancePayments', @params.insurancePaymentId)

    @route 'geofences',
      path: '/geofences'
      template: 'geofences'
      data: ->
        title: TAPi18n.__('geofences.title')
        contentClass: 'noPadding'
        topnav: <GeofencesNav />


    @route 'listDriverVehicleAssignments',
      path: '/assignments/driver/vehicle/list'
      template: 'driverVehicleAssignments'
      waitOn: ->
        [ Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('driverVehicleAssignments')]
      data: ->
        title: TAPi18n.__('driverVehicleAssignments.listTitle')
        topnav: <CrudButtons editItemTemplate='driverVehicleAssignment' i18nRoot='driverVehicleAssignments' collection=DriverVehicleAssignments removeItemMethod='removeDriverVehicleAssignment'/>

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
      waitOn: -> Meteor.subscribe('vehicle', _id: @params.vehicleId)
      data: ->
        vehicle = Vehicles.findOne(_id: @params.vehicleId)
        vehicleId: @params.vehicleId
        minTripDistance: @params.query.minTripDistance
        title: "Logbook for #{vehicle?.name} - #{vehicle?.licensePlate}" if vehicle
        topnav: <VehiclesLogbookNav />

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
      data: -> title: TAPi18n.__('expenses.listTitle')

    @route 'maintenanceReport',
      path: '/reports/maintenance'
      data: -> title: TAPi18n.__('reports.maintenance.title')

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
