toTime = FleetrGrid.Formatters.timeFormatter
aggregators = [
  new Slick.Data.Aggregators.Sum 'distance'
  new Slick.Data.Aggregators.Sum 'fuelConsumed'
]

Template.logbook2.onRendered ->
  vehicle = Vehicles.findOne(_id: @data.vehicleId)
  @deviceId = vehicle.unitId
  Meteor.call 'createTrips', @deviceId

# Template.logbook2.events
#   'input #startDate': (e, t) ->
#     Session.set 'startDate', e.target.value

Template.logbook2.helpers
  vehicleName: ->
    Vehicles.findOne(_id: Template.instance().data.vehicleId).name

# Tracker.autorun ->
#   console.log Session.get 'date'
Template.logbook2.helpers
  fleetrGridConfig: ->
    cursor: Trips.find({startTime: $gt: new Date('2015-12-01')})
    columns: [
      id: "date"
      field: "date"
      name: "Date"
      width: 50
      sortable: true
      groupable:
        aggregators: aggregators
    ,
      id: 'fromTo'
      name: 'From / To'
      field: 'startTime'
      sortable: true
      formatter: (row, cell, value, column, rowObject) ->
        "#{toTime(row,cell,rowObject.startTime)}<br />#{toTime(row, cell, rowObject.stopTime)}"
      width: 40
    ,
      id: 'beginEnd'
      name: 'Begin / End'
      formatter: (row, cell, value, column, rowObject) ->
        "#{rowObject.startAddress}<br />#{rowObject.stopAddress}"
      width: 100
    ,
      id: 'distance'
      field: 'distance'
      name: 'Distance'
      formatter: FleetrGrid.Formatters.roundFloat 2
      width: 20
      align: 'right'
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'fuel'
      field: 'fuelConsumed'
      name: 'Fuel'
      formatter: (row, cell, value) ->
        FleetrGrid.Formatters.roundFloat(2) row, cell, value/1000 if value
      width: 20
      align: 'right'
      groupTotalsFormatter: (totals, columnDef) ->
        val = totals.sum && totals.sum[columnDef.field];
        if val
          "<b>#{(Math.round(parseFloat(val)*100)/100)/1000}</b>"
        else ''
    ,
      id: 'fuelPer100'
      field: 'fuelConsumed'
      name: 'per 100km'
      formatter: (row, cell, value, column, rowObject) ->
        FleetrGrid.Formatters.roundFloat(2) row, cell, (value/rowObject.distance)/10 if value
      width: 20
      align: 'right'
    ,
      id: 'speed'
      field: 'avgSpeed'
      name: 'Speed'
      formatter: FleetrGrid.Formatters.roundFloat 0
      width: 20
      cssClass: 'from'
      align: 'right'
    ,
      id: 'maxSpeed'
      field: 'maxSpeed'
      name: 'Max Speed'
      formatter: FleetrGrid.Formatters.roundFloat 0
      width: 20
      cssClass: 'to'
      align: 'right'
    ]
    options:
      enableCellNavigation: false
      enableColumnReorder: false
      showHeaderRow: false
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 50
