Template.logbook.onRendered ->
  Meteor.call 'vehicle/history', @data.vehicle.unitId

Template.logbook.helpers
  vehicleName: -> Template.instance().data.vehicle.name
  fleetrGridConfig: ->
    cursor: VehicleHistory.find {deviceId: Template.instance().data.vehicle.unitId}, {sort: date: -1}
    pagination: true
    columns: [
      id: 'date'
      name: 'Дата'
      field: 'date'
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
    ,
      id: 'total'
      name: 'Разходи / с ДДС (лв)'
      field: 'total'
      align: 'right'
      formatter: (row, cell, value, column, rowObject) ->
        total = if value then Math.round value else ''
        totalVATIncluded = if rowObject.totalVATIncluded
          " / #{Math.round rowObject.totalVATIncluded}"
        else ''
        "#{total}#{totalVATIncluded}"
      width: 80
    ]
    options:
      multiColumnSort: true
      enableCellNavigation: false
      enableColumnReorder: false
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 30
