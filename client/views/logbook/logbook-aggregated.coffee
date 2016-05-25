Template.logbook.onRendered ->
  Meteor.call 'vehicle/history', @data.vehicle.unitId

Template.logbook.helpers
  vehicleName: -> Template.instance().data.vehicle.name
  fleetrGridConfig: ->
    cursor: VehicleHistory.find {deviceId: Template.instance().data.vehicle.unitId},
      sort:
        date: -1
      transform: (doc) -> _.extend doc,
        distance: doc.endOdometer - doc.startOdometer
    pagination: true
    columns: [
      id: 'date'
      name: 'Дата'
      field: 'date'
      width: 20
    ,
      id: 'Distance'
      name: 'Разстояние (км)'
      field: 'distance'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      align: 'right'
      width: 30
    ,
      id: 'endOdometer'
      name: 'Одометър (км в края на деня)'
      formatter: (row, cell, value) -> Math.round(value / 1000)
      field: 'endOdometer'
      align: 'right'
      width: 60
    ,
      id: 'maxSpeed'
      name: 'Максимална скорост (км/ч)'
      field: 'maxSpeed'
      align: 'right'
      formatter: (row, cell, value) -> Math.round value
      width: 60
    ,
      id: 'fuelExpenses'
      name: 'Разходи за гориво (лв с ДДС) / на 100км'
      field: 'expenses'
      align: 'right'
      formatter: (row, cell, value, column, rowObject) ->
        # total = if value?.fuels?.total then Math.round value?.fuels?.total else ''
        totalVATIncluded = if value?.fuels?.totalVATIncluded
          "#{value.fuels.totalVATIncluded.toFixed(2)}"
        else ''
        per100km = if rowObject.distance and value?.fuels?.totalVATIncluded
          " / #{(value.fuels.totalVATIncluded / (rowObject.distance / 100000)).toFixed(2)}"
        else ''
        "#{totalVATIncluded}#{per100km}"
      width: 80
    ]
    options:
      multiColumnSort: true
      enableCellNavigation: false
      enableColumnReorder: false
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 30
