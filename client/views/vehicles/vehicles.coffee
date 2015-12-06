lastUpdateFormatter = (daysAgo) -> (row, cell, value) ->
  if value
    lastUpdate = moment value
    aWeekAgo = moment().subtract(daysAgo, 'days')
    longAgoWarning = TAPi18n.__('vehicles.lastUpdateTooLongAgoWarning')
    attnIcon = if lastUpdate.isBefore(aWeekAgo)
      "<i class='fa fa-exclamation-triangle' style='color:red;' title='#{longAgoWarning}'></i> "
    else
      ''
    "<span>#{attnIcon}#{lastUpdate.format('DD/MM/YYYY HH:mm:ss')}</span>"
  else
    noDataWarning = TAPi18n.__('vehicles.lastUpdateNoDataWarning')
    "<i class='fa fa-exclamation-triangle' style='color:red;' title='#{noDataWarning}'></i>"

statusFormatter = (row, cell, value) ->
  if value
    if value == "stop"
      "<img src='/images/truck-state-blue.png'}'></img> "
    else
      if value == "start"
        "<img src='/images/truck-state-green.png'}'></img> "
      else
        "<img src='/images/truck-state-grey.png'}'></img> "
  else
    "<img src='/images/truck-state-grey.png'}'></img> "

Template.maintenancesButton.helpers
  vehicleId: => Session.get "selectedItemId"

Template.vehicles.helpers
  options: ->
    i18nRoot: 'vehicles'
    collection: Vehicles
    editItemTemplate: 'vehicle'
    removeItemMethod: 'removeVehicle'
    additionalItemActionsTemaplate: 'maintenancesButton'
    gridConfig:
      columns: [
        id: "state"
        field: "state"
        name: ""
        width: 1
        sortable: true
        search: where: 'client'
        formatter: statusFormatter
      ,
        id: "speed"
        field: "speed"
        name: TAPi18n.__('vehicles.speed')
        width: 40
        sortable: true
        align: 'right'
        search: where: 'client'
        formatter: FleetrGrid.Formatters.roundFloat(2)
      ,
        id: "fleetName"
        field: "fleetName"
        name: TAPi18n.__('fleet.name')
        width:80
        sortable: true
        hidden:true
        search: where: 'client'
        groupable:
          aggregators: []
      ,
        id: "name"
        field: "name"
        name: TAPi18n.__('vehicles.name')
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "licensePlate"
        field: "licensePlate"
        name: TAPi18n.__('vehicles.licensePlate')
        width:50
        sortable: true
        search: where: 'client'
      ,
        id: "unitId"
        field: "unitId"
        name: TAPi18n.__('vehicles.unitId')
        width:50
        hidden: true
        sortable: true
        search: where: 'client'
      ,
        id: "phoneNumber"
        field: "phoneNumber"
        name: TAPi18n.__('vehicles.phoneNumber')
        width:50
        hidden: true
        sortable: true
        search: where: 'client'
      ,
        id: "odometer"
        field: "odometer"
        name: TAPi18n.__('vehicles.odometer')
        width:50
        align: 'right'
        sortable: true
        search: where: 'client'
      ,
        id: "lastUpdate"
        field: "lastUpdate"
        name: TAPi18n.__('vehicles.lastUpdate')
        width:60
        sortable: true
        formatter: lastUpdateFormatter(7)
        search:
          where: 'server'
          dateRange: DateRanges.history
      ,
        id: "tags"
        field: "tags"
        name: TAPi18n.__('vehicles.tags')
        width:60
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Vehicles.find {},
        transform: (doc) -> _.extend doc,
            fleetName: Fleets.findOne(_id: doc.allocatedToFleet)?.name
