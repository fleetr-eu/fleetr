Template.customEvents.helpers
  events: -> 
    CustomEvents.find().map( (doc) ->
        title: doc.name,
        start: doc.date,
        end: doc.date,
        allDay: true)

  options: ->
    i18nRoot: 'customEvents'
    collection: CustomEvents
    editItemTemplate: 'customEvent'
    removeItemMethod: 'removeCustomEvent'
    gridConfig:
      cursor: CustomEvents.find {},
        transform: (doc) -> _.extend doc,
          fleetGroupName: FleetGroups.findOne(_id: doc.fleetGroupId)?.name
          fleetName: Fleets.findOne(_id: doc.fleetId)?.name
          vehicleName: Vehicles.findOne(_id: doc.vehicleId)?.name
          driverName: Drivers.findOne(_id: doc.driverId)?.name
          remainingDays: if doc.date then moment(doc.date).diff(moment(), 'days') else -1
          remainingKm: if doc.odometer then doc.odometer - Vehicles.findOne(_id: doc.vehicleId)?.odometer else -1
      columns: [
        id: "name"
        field: "name"
        name: "#{TAPi18n.__('customEvents.name')}"
        width:80
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "fleetGroupName"
        field: "fleetGroupName"
        name: "#{TAPi18n.__('customEvents.fleetGroup')}"
        width:80
        hidden: true
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "fleetName"
        field: "fleetName"
        name: "#{TAPi18n.__('customEvents.fleet')}"
        width:80
        hidden: true
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "vehicleName"
        field: "vehicleName"
        name: "#{TAPi18n.__('customEvents.vehicle')}"
        width:80
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "driverName"
        field: "driverName"
        name: "#{TAPi18n.__('customEvents.driver')}"
        width:80
        sortable: true
        search: where: 'client'
        hidden: true
        groupable: true
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('customEvents.description')}"
        hidden: true
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "date"
        field: "date"
        name: "#{TAPi18n.__('customEvents.date')}"
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
        search:
            where: 'server'
            dateRange: DateRanges.future
        groupable: true
      ,
        id: "remainingDays"
        field: "remainingDays"
        name: "#{TAPi18n.__('customEvents.remainingDays')}"
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.decoratedLessThanFormatter(2, 8)
        search: where: 'client'
      ,
        id: "odometer"
        field: "odometer"
        name: "#{TAPi18n.__('customEvents.odometer')}"
        align: 'right'
        width:40
        sortable: true
        search: where: 'client'
      ,
        id: "remainingKm"
        field: "remainingKm"
        name: "#{TAPi18n.__('customEvents.remainingKm')}"
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.decoratedLessThanFormatter(101, 501)
        search: where: 'client'
      ,
        id: "engineHours"
        field: "engineHours"
        name: "#{TAPi18n.__('customEvents.engineHours')}"
        width:40
        sortable: true
        search: where: 'client'
        hidden: true
      ,
        id: "speed"
        field: "speed"
        name: "#{TAPi18n.__('customEvents.speed')}"
        width:40
        sortable: true
        search: where: 'client'
      ,
        id: "seen"
        field: "seen"
        name: TAPi18n.__('customEvents.seen')
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.seenNotification
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
