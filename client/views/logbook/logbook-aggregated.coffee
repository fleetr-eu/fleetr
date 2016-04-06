Template.logbook.helpers
  vehicleName: -> Template.instance().data.vehicle.name
  fleetrGridConfig: ->
    remoteMethod: "aggregateLogbook"
    remoteMethodParams: Template.instance().data.vehicle.unitId
    pagination: true
    columns: [
      id: 'date'
      name: 'Дата'
      field: 'recordTime'
      formatter: FleetrGrid.Formatters.dateFormatter
      width: 80
    ,
      id: 'Odometer'
      name: 'Разстояние (км)'
      field: 'startOdometer'
      formatter: (row, cell, value, column, rowObject) ->
        Math.round((rowObject.endOdometer - value) / 1000)
      align: 'right'
      width: 80
    ,
      id: 'endOdometer'
      name: 'Одометър (км в края на деня)'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      align: 'right'
      width: 80
    ,
      id: 'maxSpeed'
      name: 'Максимална скорост (км/ч)'
      field: 'maxSpeed'
      align: 'right'
      formatter: (row, cell, value) -> Math.round value
      width: 80
    ]
    # customize: (grid) ->
    #   grid.setColumnFilterValue {id: 'deviceId'}, 7660420
    options:
      multiColumnSort: true
      enableCellNavigation: false
      enableColumnReorder: false
      # showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 30
