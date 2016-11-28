aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
]

Template.fullLogbookReport.helpers
  pageTitle: -> TAPi18n.__('menu.logbook')
  fleetrGridConfig: ->
    columns: [
      id: "date"
      field: "date"
      name: TAPi18n.__('time.date')
      width:30
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: "vehicleName"
      field: "vehicleName"
      name: TAPi18n.__('vehicles.title')
      width:50
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: "fleetName"
      field: "fleetName"
      name: TAPi18n.__('fleet.title')
      width:50
      sortable: true
      search: where: 'client'
      groupable:
        aggregators: aggregators
    ,
      id: 'Distance'
      name: TAPi18n.__('reports.logbook.distance')
      field: 'distance'
      formatter: (row, cell, value) -> Math.round(value)
      align: 'right'
      width: 40
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'endOdometer'
      name: TAPi18n.__('reports.logbook.odometer')
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      align: 'right'
      width: 40
    ,
      id: 'maxSpeed'
      name: TAPi18n.__('reports.logbook.maxSpeed')
      field: 'maxSpeed'
      align: 'right'
      formatter: (row, cell, value) -> Math.round value
      width: 30
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    remoteMethod: 'fullLogbook'
