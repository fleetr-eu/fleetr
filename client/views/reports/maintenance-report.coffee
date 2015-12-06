remainingFormater = (daysRed, daysOrange, decimals = 0) -> (row, cell, value) ->
  if value
    v = Number((Number(value)).toFixed(decimals))
    attnIcon = ''
    if v < daysRed
      attnIcon = "<i class='fa fa-exclamation-triangle' style='color:red;' title='#{v}'></i>"
    else 
       if value < daysOrange 
        attnIcon = "<i class='fa fa-exclamation-triangle' style='color:orange;' title='#{v}'></i>"
    "<span>#{attnIcon}<div class='pull-right'>#{v}</div></span>"

getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

Template.maintenanceReport.helpers
  pageTitle: -> TAPi18n.__('reports.maintenance.title')
  fleetrGridConfig: ->
    columns: [
      id: "fleetName"
      field: "fleetName"
      name: TAPi18n.__('fleet.title')
      width:100
      sortable: true
      search:
        where: 'client'
      groupable: true
    ,
      id: "vehicleName"
      field: "vehicleName"
      name: TAPi18n.__('vehicles.title')
      width:100
      sortable: true
      search:
        where: 'client'
      groupable: true
    ,
      id: "nextMaintenanceDate"
      field: "nextMaintenanceDate"
      name: TAPi18n.__('reports.maintenance.nextMaintenanceDate')
      width:50
      sortable: true
      align: 'left'
      formatter: FleetrGrid.Formatters.dateFormatter
      search:
        where: 'server'
        dateRange: DateRanges.future
      groupable: true
    ,
      id: "daysToMaintenance"
      field: "daysToMaintenance"
      name: TAPi18n.__('reports.maintenance.daysToMaintenance')
      width:50
      sortable: true
      formatter: remainingFormater(2, 10)
      search: where: 'server'
    ,
      id: 'nextMaintenanceOdometer'
      field: 'nextMaintenanceOdometer'
      name: TAPi18n.__('reports.maintenance.nextMaintenanceOdometer')
      width:50
      align: 'right'
      sortable: true
      search: where: 'client'
    ,
      id: 'odometerToMaintenance'
      field: 'odometerToMaintenance'
      name: TAPi18n.__('reports.maintenance.odometerToMaintenance')
      width:50
      sortable: true
      formatter: remainingFormater(100, 500)
      search: where: 'server'
    ,
      id: 'nextMaintenanceEngineHours'
      field: 'nextMaintenanceEngineHours'
      name: TAPi18n.__('reports.maintenance.nextMaintenanceEngineHours')
      width:50
      hidden: true
      align: 'right'
      sortable: true
      search: where: 'server'
    ,
      id: 'engineHoursToMaintenance'
      field: 'engineHoursToMaintenance'
      name: TAPi18n.__('reports.maintenance.engineHoursToMaintenance')
      width:50
      hidden: true
      sortable: true
      formatter: remainingFormater(20, 100)
      search: where: 'server'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    remoteMethod: 'getMaintenanceVehicles'
    # customize: (grid) ->
    #   now = moment()
    #   future = moment().add(1, 'months')
    #   grid.addFilter 'server', TAPi18n.__('reports.maintenance.nextMaintenanceDate'), "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
    #     {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}, false