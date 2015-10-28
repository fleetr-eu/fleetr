toTime = FleetrGrid.Formatters.timeFormatter
fleetrGridConfig =
  columns: [
    id: "date"
    field: "date"
    name: "Date"
    width: 50
    sortable: true
    groupable: true
  ,
  #   id: 'from'
  #   field: 'startTime'
  #   name: 'From'
  #   formatter: FleetrGrid.Formatters.timeFormatter
  #   width: 10
  #   cssClass: 'from'
  # ,
  #   id: 'to'
  #   field: 'stopTime'
  #   name: 'To'
  #   formatter: FleetrGrid.Formatters.timeFormatter
  #   width: 10
  #   cssClass: 'to'
  # ,
    id: 'fromTo'
    name: 'From/To'
    formatter: (row, cell, value, column, rowObject) ->
      "#{toTime(row,cell,rowObject.startTime)} <span class=\"glyphicon glyphicon-arrow-right\" aria-hidden=\"true\"></span> #{toTime(row, cell, rowObject.stopTime)}"
    width:25
  ,
    id: 'startAddress'
    field: 'startAddress'
    name: 'Begin'
    width: 100
  ,
    id: 'stopAddress'
    field: 'stopAddress'
    name: 'End'
    width: 100
  ,
    id: 'distance'
    field: 'sumDistance'
    name: 'Distance'
    formatter: FleetrGrid.Formatters.roundFloat 2
    width: 20
  ,
    id: 'fuel'
    field: 'sumFuel'
    name: 'Fuel'
    formatter: (row, cell, value) ->
      FleetrGrid.Formatters.roundFloat(2) row, cell, value/1000 if value
    width: 20
  ,
    id: 'fuelPer100'
    field: 'sumFuel'
    name: 'per 100km'
    formatter: (row, cell, value, column, rowObject) ->
      FleetrGrid.Formatters.roundFloat(2) row, cell, (value/rowObject.sumDistance)/100 if value
    width: 20
  ,
    id: 'speed'
    field: 'avgSpeed'
    name: 'Speed'
    formatter: FleetrGrid.Formatters.roundFloat 0
    width: 20
    cssClass: 'from'
  ,
    id: 'maxSpeed'
    field: 'maxSpeed'
    name: 'Max Speed'
    formatter: FleetrGrid.Formatters.roundFloat 0
    width: 20
    cssClass: 'to'
  ]
  options:
    enableCellNavigation: false
    enableColumnReorder: false
    showHeaderRow: false
    explicitInitialization: true
    forceFitColumns: true
  cursor: -> AggByDate.find()
  # customize: (grid) ->
  #   now = moment()
  #   future = moment().add(29, 'days')
  #   grid.addFilter 'server', 'Maintenance Date', "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
  #     {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}, false

Template.logbook2.helpers
  fleetrGridConfig: -> fleetrGridConfig
