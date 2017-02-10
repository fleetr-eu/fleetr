React       = require 'react'
CrudButtons = require '/imports/ui/CrudButtons.cjsx'
MapAdditionalControls = require '/imports/ui/MapAdditionalControls.cjsx'
GeofencesNav          = require '/imports/ui/navs/GeofencesNav.cjsx'
VehiclesLogbookNav    = require '/imports/ui/navs/VehiclesLogbookNav.cjsx'
ImportExpensesNav     = require '/imports/ui/navs/ImportExpensesNav.cjsx'
IconButton  = require '/imports/ui/buttons/IconButton.cjsx'

exportVehiclesToCSV = require '/imports/actions/exportVehiclesToCSV.coffee'

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

    @route '/', ->
      @redirect '/vehicles/map'

    # @route 'dashboard',
    #   path: '/'
    #   template: 'menuBoard'
    #   fastRender: true
    #   waitOn: -> Meteor.subscribe('vehicles')

    @route 'settings',
      path: '/settings'
      template: 'configurationSettings'
      waitOn: -> [Meteor.subscribe('configurationSettings')]
      data: ->
        title: TAPi18n.__('menu.configurationSettings')
        topnav:
          <CrudButtons editItemTemplate='configurationSetting'
                       i18nRoot='configurationSettings'
                       collection=ConfigurationSettings
                       removeItemMethod='removeConfigurationSetting' />


    @route 'odometers',
      path: '/odometers'
      template: 'odometerCorrections'
      waitOn: -> [Meteor.subscribe('vehicles')]

    @route 'listAlarms',
      path: '/alarms/list'
      template: 'alarms'
      waitOn: -> [Meteor.subscribe('alarms'), Meteor.subscribe('geofenceEvents'), Meteor.subscribe('customEvents')]
      data: ->
        title: TAPi18n.__('alarms.listTitle')
        topnav: <CrudButtons editItemTemplate='alarm' i18nRoot='alarms' collection=Alarms removeItemMethod='removeAlarm' />

    @route 'listVehicles',
      path: '/vehicles/list/:fleetName?'
      template: 'vehicles'
      waitOn: -> [
        Meteor.subscribe('vehicles/list')
        Meteor.subscribe('fleetsForVehicleList')
        Meteor.subscribe('drivers')
      ]
      data: ->
        fleetName: @params.fleetName
        title: TAPi18n.__('vehicles.listTitle')
        topnav: <CrudButtons editItemTemplate='vehicle' i18nRoot='vehicles'
                      showMaintenancesButton=true collection=Vehicles
                      removeItemMethod='removeVehicle'>
                  <li>
                    <IconButton title={TAPi18n.__("button.exportToCSV")}
                                className='pe-7s-download'
                                onClick={exportVehiclesToCSV} />
                  </li>
                </CrudButtons >

    @route 'listCustomEvents',
      path: '/custom-events/list'
      template: 'customEvents'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__ 'customEvents.listTitle'
        topnav:
          <CrudButtons editItemTemplate='customEvent' i18nRoot='customEvents' collection=CustomEvents removeItemMethod='removeCustomEvent'>
            <li><a href={Router.path 'listGeofenceEvents'}>{TAPi18n.__("geofenceEvents.listTitle")}</a></li>
          </CrudButtons>

    @route 'listGeofenceEvents',
      path: '/geofence-events/list'
      template: 'geofenceEvents'
      waitOn: -> [Meteor.subscribe('geofenceEvents'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('fleets'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('geofences')]
      data: ->
        title: TAPi18n.__ 'geofenceEvents.listTitle'
        topnav:
          <CrudButtons editItemTemplate='geofenceEvent' i18nRoot='geofenceEvents' collection=GeofenceEvents removeItemMethod='removeGeofenceEvent'>
            <li><a href={Router.path 'listCustomEvents'}>{TAPi18n.__("customEvents.listTitle")}</a></li>
          </CrudButtons>

    @route 'listTyres',
      path: '/tyres/list'
      template: 'tyres'
      waitOn: -> [Meteor.subscribe('tyres'), Meteor.subscribe('vehicles')]
      data: ->
        title: TAPi18n.__('tyre.listTitle')
        topnav:
          <CrudButtons editItemTemplate='tyre' i18nRoot='tyre' collection=Tyres removeItemMethod='removeTyre'>
            <li><a href={Router.path 'listMaintenanceType'}>{TAPi18n.__("menu.listMaintenanceTypes")}</a></li>
          </CrudButtons>

    @route 'listFleets',
      path: '/fleets/list'
      template: 'fleets'
      waitOn: -> [Meteor.subscribe('customEvents'), Meteor.subscribe('fleets'), Meteor.subscribe('fleetGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__('fleet.listTitle')
        topnav:
          <CrudButtons editItemTemplate='fleet' i18nRoot='fleet' collection=Fleets removeItemMethod='removeFleet'>
            <li><a href={Router.path 'listFleetGroups'}>{TAPi18n.__("menu.listFleetGroups")}</a></li>
          </CrudButtons>

    @route 'listFleetGroups',
      path: '/fleets/groups/list'
      template: 'fleetGroups'
      waitOn: -> Meteor.subscribe('fleetGroups')
      data: ->
        title: TAPi18n.__('fleetGroups.listTitle')
        topnav:
          <CrudButtons editItemTemplate='fleetGroup' i18nRoot='fleetGroups' collection=FleetGroups removeItemMethod='removeFleetGroup'>
            <li><a href={Router.path 'listFleets'}>{TAPi18n.__("menu.listFleets")}</a></li>
          </CrudButtons>

    @route 'mapVehicles',
      path: '/vehicles/map/:vehicleId?'
      template: 'map'
      waitOn: ->
        vehicle = Vehicles.findOne _id: @params.vehicleId
        [
          Meteor.subscribe('geofences')
          Meteor.subscribe('vehicle', {_id: @params.vehicleId})
          Meteor.subscribe('vehicles')
          Meteor.subscribe('drivers')
          Meteor.subscribe('fleets')
          Meteor.subscribe('logbook/trip', vehicle?.trip?.id)
        ]
      data: ->
        vehicleId: @params.vehicleId
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
      data: ->
        title: TAPi18n.__('expenses.import.title')
        topnav:
          #<ImportExpensesNav />
          <ul className="nav navbar-nav navbar-left" style={height:60}>
            <li style={borderLeft:'1px solid #9A9A9A', height: 50, margin: 5} />
            <li><a href={Router.path 'listExpenses'}>{TAPi18n.__("expenses.listTitle")}</a></li>
            <li><a href={Router.path 'listExpenseGroups'}>{TAPi18n.__("expenseGroups.listTitle")}</a></li>
            <li><a href={Router.path 'listExpenseTypes'}>{TAPi18n.__("expenseTypes.listTitle")}</a></li>
          </ul>

    @route 'listExpenseGroups',
      path: '/expenses/groups/list'
      template: 'expenseGroups'
      waitOn: -> Meteor.subscribe('expenseGroups')
      data: ->
        title: TAPi18n.__('expenseGroups.listTitle')
        topnav:
          <CrudButtons editItemTemplate='expenseGroup' i18nRoot='expenseGroups' collection=ExpenseGroups removeItemMethod='removeExpenseGroup'>
            <li><a href={Router.path 'listExpenses'}>{TAPi18n.__("expenses.listTitle")}</a></li>
            <li><a href={Router.path 'listExpenseTypes'}>{TAPi18n.__("expenseTypes.listTitle")}</a></li>
            <li><a href={Router.path 'importExpenses'}>{TAPi18n.__("expenses.import.title")}</a></li>
          </CrudButtons>

    @route 'listExpenseTypes',
      path: '/expenses/types/list'
      template: 'expenseTypes'
      waitOn: -> Meteor.subscribe('expenseTypes')
      data: ->
        title: TAPi18n.__('expenseTypes.listTitle')
        topnav:
          <CrudButtons editItemTemplate='expenseType' i18nRoot='expenseTypes' collection=ExpenseTypes removeItemMethod='removeExpenseType'>
            <li><a href={Router.path 'listExpenses'}>{TAPi18n.__("expenses.listTitle")}</a></li>
            <li><a href={Router.path 'listExpenseGroups'}>{TAPi18n.__("expenseGroups.listTitle")}</a></li>
            <li><a href={Router.path 'importExpenses'}>{TAPi18n.__("expenses.import.title")}</a></li>
          </CrudButtons>

    @route 'listExpenses',
      path: '/expenses/list'
      template: 'expenses'
      waitOn: -> [Meteor.subscribe('expenses'), Meteor.subscribe('expenseTypes'), Meteor.subscribe('expenseGroups'), Meteor.subscribe('vehicles'), Meteor.subscribe('drivers')]
      data: ->
        title: TAPi18n.__('expenses.listTitle')
        topnav:
          <CrudButtons editItemTemplate='expense' i18nRoot='expenses' collection=Expenses removeItemMethod='removeExpense'>
            <li><a href={Router.path 'listExpenseGroups'}>{TAPi18n.__("expenseGroups.listTitle")}</a></li>
            <li><a href={Router.path 'listExpenseTypes'}>{TAPi18n.__("expenseTypes.listTitle")}</a></li>
            <li><a href={Router.path 'importExpenses'}>{TAPi18n.__("expenses.import.title")}</a></li>
          </CrudButtons>

    @route 'listDrivers',
      path: '/drivers/list'
      template: 'drivers'
      waitOn: -> [Meteor.subscribe('drivers'), Meteor.subscribe('vehicles')]
      data: ->
        title: TAPi18n.__('drivers.listTitle')
        topnav:
          <CrudButtons editItemTemplate='driver' i18nRoot='drivers' collection=Drivers removeItemMethod='removeDriver' showDocumentsButton={true}>
            <li><a href={Router.path 'listDriverVehicleAssignments'}>{TAPi18n.__("driverVehicleAssignments.listTitle")}</a></li>
            <li><a href={Router.path 'listDocumentTypes'}>{TAPi18n.__("documentTypes.listTitle")}</a></li>
          </CrudButtons>

    @route 'listDocumentTypes',
      path: '/documents/types/list'
      template: 'documentTypes'
      waitOn: -> Meteor.subscribe('documentTypes')
      data: ->
        title: TAPi18n.__('documentTypes.listTitle')
        topnav:
          <CrudButtons editItemTemplate='documentType' i18nRoot='documentTypes' collection=DocumentTypes removeItemMethod='removeDocumentType'>
            <li><a href={Router.path 'listDrivers'}>{TAPi18n.__("drivers.listTitle")}</a></li>
            <li><a href={Router.path 'listDriverVehicleAssignments'}>{TAPi18n.__("driverVehicleAssignments.listTitle")}</a></li>
          </CrudButtons>

    @route 'listDriverVehicleAssignments',
      path: '/assignments/driver/vehicle/list'
      template: 'driverVehicleAssignments'
      waitOn: ->
        [ Meteor.subscribe('vehicles'), Meteor.subscribe('drivers'), Meteor.subscribe('driverVehicleAssignments')]
      data: ->
        title: TAPi18n.__('driverVehicleAssignments.listTitle')
        topnav:
          <CrudButtons editItemTemplate='driverVehicleAssignment' i18nRoot='driverVehicleAssignments' collection=DriverVehicleAssignments removeItemMethod='removeDriverVehicleAssignment'>
            <li><a href={Router.path 'listDrivers'}>{TAPi18n.__("drivers.listTitle")}</a></li>
            <li><a href={Router.path 'listDocumentTypes'}>{TAPi18n.__("documentTypes.listTitle")}</a></li>
          </CrudButtons>


    @route 'listDocuments',
      path: '/drivers/:driverId/documents/list'
      template: 'documents'
      waitOn: -> [Meteor.subscribe('documents', @params.driverId), Meteor.subscribe('documentTypes')]
      data: ->
        title: TAPi18n.__('documents.listTitle')
        driverId: @params.driverId
        topnav:
          <CrudButtons editItemTemplate='document'
                       i18nRoot='documents'
                       collection=Documents
                       removeItemMethod='removeDocument'/>

    @route 'listMaintenances',
      path: '/vehicle/:vehicleId/maintenance/list'
      template: 'maintenances'
      waitOn: ->
        [Meteor.subscribe('vehicle', _id: @params.vehicleId)
        Meteor.subscribe('vehicleMaintenances', @params.vehicleId)
        Meteor.subscribe('maintenanceTypes')]
      data: ->
        vehicleId: @params.vehicleId
        title: TAPi18n.__('maintenances.listTitle')
        topnav:
          <CrudButtons editItemTemplate='maintenance'
                       i18nRoot='maintenances'
                       collection=Maintenances
                       removeItemMethod='removeMaintenance'/>

    @route 'listOdometers',
      path: '/vehicle/:vehicleId/odometers/list'
      template: 'odometers'
      data: -> {'vehicleId' : @params.vehicleId}
      waitOn: ->
        [ Meteor.subscribe('vehicle', _id: @params.vehicleId)
          Meteor.subscribe('vehicleOdometers', @params.vehicleId) ]

    @route 'listMaintenanceType',
      path: '/maintenance/types/list'
      template: 'maintenanceTypes'
      waitOn: ->
        Meteor.subscribe('maintenanceTypes')
      data: ->
        title: TAPi18n.__('maintenanceTypes.listTitle')
        topnav:
          <CrudButtons editItemTemplate='maintenanceType' i18nRoot='maintenanceTypes' collection=MaintenanceTypes removeItemMethod='removeMaintenanceType'>
            <li><a href={Router.path 'listTyres'}>{TAPi18n.__("menu.listTyres")}</a></li>
          </CrudButtons>


    @route 'listInsuranceTypes',
      path: '/insurance/types/list'
      template: 'insuranceTypes'
      waitOn: ->
        Meteor.subscribe('insuranceTypes')
      data: ->
        title: TAPi18n.__('insuranceTypes.listTitle')
        topnav:
          <CrudButtons editItemTemplate='insuranceType' i18nRoot='insuranceTypes' collection=InsuranceTypes removeItemMethod='removeInsuranceTypes'>
            <li><a href={Router.path 'listInsurances'}>{TAPi18n.__("menu.insurances")}</a></li>
          </CrudButtons>

    @route 'listInsurances',
      path: '/insurance/list'
      template: 'insurances'
      waitOn: ->
        [Meteor.subscribe('insurances', @params.insuranceId)
        Meteor.subscribe('vehicles/names')
        Meteor.subscribe('insuranceTypes')]
      data: ->
        title: TAPi18n.__('insurances.listTitle')
        topnav: <CrudButtons editItemTemplate='insurance' i18nRoot='insurances'
                  collection=Insurances removeItemMethod='removeInsurance'
                  showInsurancePaymentsButton=true>
          <li><a href={Router.path 'listInsuranceTypes'}>{TAPi18n.__("menu.listInsuranceTypes")}</a></li>
        </CrudButtons>

    @route 'listInsurancePayments',
      path: '/insurance/:insuranceId/payment/list'
      template: 'insurancePayments'
      waitOn: -> [
        Meteor.subscribe('insurance', @params.insuranceId)
        Meteor.subscribe('vehicleForInsurance', @params.insuranceId)
        Meteor.subscribe('insurancePayments', @params.insuranceId)
      ]
      data: ->
        insuranceId : @params.insuranceId
        title: TAPi18n.__('insurancePayments.listTitle')
        topnav: <CrudButtons editItemTemplate='insurancePayment'
                      i18nRoot='insurancePayments'
                      collection=InsurancePayments
                      removeItemMethod='removeInsurancePayment'>
          <li><a href={Router.path 'listInsurances'}>{TAPi18n.__("menu.insurances")}</a></li>
          <li><a href={Router.path 'listInsuranceTypes'}>{TAPi18n.__("menu.listInsuranceTypes")}</a></li>
        </CrudButtons>

    @route 'geofences',
      path: '/geofences'
      template: 'geofences'
      data: ->
        title: TAPi18n.__('geofences.title')
        contentClass: 'noPadding'
        topnav: <GeofencesNav />


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
      data:
        title: TAPi18n.__('menu.logbook')

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

    @route 'vehicleLogbookReact',
      path: '/vehicles/:vehicleId/logbook-react'
      template: 'logbook-react'
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
        vehicle = Vehicles.findOne {_id: @params.vehicleId},
          fields:
            unitId: 1
            name: 1
        vehicle: vehicle
        title: "History for #{vehicle.name}" if vehicle


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


    @route 'simple-map',
      path: '/map/:data?'
      template: 'simpleMap'
      data: ->
        parsed = EJSON.parse decodeURIComponent @params?.data
        vehicle = Vehicles.findOne unitId: parsed.deviceId
        parsed: parsed
        contentClass: 'noPadding'
        title: "#{vehicle.name} - #{vehicle.licensePlate}" if vehicle
      waitOn: -> [ Meteor.subscribe('geofences')
                  Meteor.subscribe('drivers')
                  Meteor.subscribe('vehicle', {unitId: JSON.parse(@params.data).deviceId})]

    @route 'reports/proximity',
      path: '/reports/proximity'
      template: 'proximity'
      data: ->
        title: TAPi18n.__('reports.proximity.title')
      waitOn: -> []
