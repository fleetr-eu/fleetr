Template.geofenceEvents.helpers
  options: ->
    i18nRoot: 'geofenceEvents'
    collection: GeofenceEvents
    editItemTemplate: 'geofenceEvent'
    removeItemMethod: 'removeGeofenceEvent'
    gridConfig:
      cursor: GeofenceEvents.find {},
        transform: (doc) -> _.extend doc,
          geofenceName: Geofences.findOne(_id: doc.geofenceId)?.name
          fleetGroupName: FleetGroups.findOne(_id: doc.fleetGroupId)?.name
          fleetName: Fleets.findOne(_id: doc.fleetId)?.name
          vehicleName: Vehicles.findOne(_id: doc.vehicleId)?.name
          driverName: Drivers.findOne(_id: doc.driverId)?.name
      columns: [
        id: "active"
        field: "active"
        name: "#{TAPi18n.__('geofenceEvents.active')}"
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeEvent
      ,
        id: "geofenceName"
        field: "geofenceName"
        name: "#{TAPi18n.__('geofenceEvents.geofence')}"
        width:80
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "fleetGroupName"
        field: "fleetGroupName"
        name: "#{TAPi18n.__('geofenceEvents.fleetGroup')}"
        width:80
        hidden: true
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "fleetName"
        field: "fleetName"
        name: "#{TAPi18n.__('geofenceEvents.fleet')}"
        width:80
        hidden: true
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "vehicleName"
        field: "vehicleName"
        name: "#{TAPi18n.__('geofenceEvents.vehicle')}"
        width:80
        sortable: true
        search: where: 'client'
        groupable: true
      ,
        id: "driverName"
        field: "driverName"
        name: "#{TAPi18n.__('geofenceEvents.driver')}"
        width:80
        sortable: true
        search: where: 'client'
        hidden: true
        groupable: true
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('geofenceEvents.description')}"
        hidden: true
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "enter"
        field: "enter"
        name: TAPi18n.__('geofenceEvents.enter')
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeEvent
      ,
        id: "exit"
        field: "exit"
        name: TAPi18n.__('geofenceEvents.exit')
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeEvent
      ,
        id: "stay"
        field: "stay"
        name: TAPi18n.__('geofenceEvents.stay')
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeEvent
      ,
        id: "minutes"
        field: "minutes"
        name: "#{TAPi18n.__('geofenceEvents.minutes')}"
        width:20
        sortable: true
        search: where: 'client'
      ,
        id: "seen"
        field: "seen"
        name: TAPi18n.__('geofenceEvents.seen')
        width:20
        sortable: true
        search: false
        align: 'center'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.activeEvent
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
