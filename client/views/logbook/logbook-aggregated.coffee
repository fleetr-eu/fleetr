Template.logbook.helpers
  fleetrGridConfig: ->
    remoteMethod: "aggregateLogbook"
    remoteMethodParams: 7660420
    pagination: true
    columns: [
      id: 'date'
      name: 'Date'
      field: 'recordTime'
      formatter: FleetrGrid.Formatters.dateFormatter
      width: 80
    ,
      id: 'Odometer'
      name: 'Distance (km)'
      field: 'startOdometer'
      formatter: (row, cell, value, column, rowObject) ->
        Math.round((rowObject.endOdometer - value) / 1000)
      width: 80
    ,
      id: 'endOdometer'
      name: 'Odometer (km, end of day)'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      width: 80
    ,
      id: 'maxSpeed'
      name: 'Max Speed'
      field: 'maxSpeed'
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
      # forceFitColumns: true
      rowHeight: 40
