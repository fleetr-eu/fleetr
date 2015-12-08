hiddenOnMobile = () -> 
  Session.get('device-screensize') is 'small'

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
  color = 'grey'
  if value
    if value == "stop"
      color = "blue"
      if value == "start"
        color = 'green'
  "<img src='/images/truck-state-#{color}.png'></img>"  

logbookLinkFormatter = (row, cell, value) ->
  "<a href='/vehicles/#{value}/logbook'><img src='/images/logbook-icon.png' height='22' }'></img></a>"
 
mapLinkFormatter = (row, cell, value) ->
  "<a href='/vehicles/map/#{value}'><img src='/images/Google-Maps-icon.png' height='22'}'></img></a>" 

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
        name: TAPi18n.__('vehicles.stateShort')
        maxWidth: 38
        sortable: true
        search: where: 'client'
        formatter: statusFormatter
        align: 'left'
      ,
        id: "speed"
        field: "speed"
        name: TAPi18n.__('vehicles.speedShort')
        maxWidth: 50
        sortable: true
        align: 'right'
        search: where: 'client'
        formatter: FleetrGrid.Formatters.decoratedGreaterThanFormatter(50, 100, 0)
      ,
        id: "map"
        field: "_id"
        name: TAPi18n.__('vehicles.mapShort')
        maxWidth: 31
        formatter: mapLinkFormatter
        align: 'left'
      ,
        id: "logbook"
        field: "_id"
        name: TAPi18n.__('vehicles.logbookShort')
        maxWidth: 31
        formatter: logbookLinkFormatter
        align: 'left'
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
        id: "vehicleShowName"
        field: "vehicleShowName"
        name: TAPi18n.__('vehicles.name')
        width:100
        sortable: true
        hidden: not hiddenOnMobile()
        search: where: 'client'    
      ,
        id: "name"
        field: "name"
        name: TAPi18n.__('vehicles.name')
        width:100
        sortable: true
        hidden: hiddenOnMobile()
        search: where: 'client'
      ,
        id: "licensePlate"
        field: "licensePlate"
        name: TAPi18n.__('vehicles.licensePlate')
        width:50
        sortable: true
        hidden: hiddenOnMobile()
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
        field: "odo"
        name: TAPi18n.__('vehicles.odometer')
        width:50
        align: 'right'
        sortable: true
        hidden: hiddenOnMobile()
        search: where: 'client'
        formatter: FleetrGrid.Formatters.roundFloat(0)
      ,
        id: "lastUpdate"
        field: "lastUpdate"
        name: TAPi18n.__('vehicles.lastUpdate')
        width:60
        sortable: true
        formatter: lastUpdateFormatter(7)
        hidden: hiddenOnMobile()
        search:
          where: 'server'
          dateRange: DateRanges.history
      ,
        id: "tags"
        field: "tags"
        name: TAPi18n.__('vehicles.tags')
        width:60
        sortable: true
        hidden: hiddenOnMobile()
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
            vehicleShowName: doc.name + ' (' + doc.licensePlate + ')'
            odo: doc.odometer / 1000
