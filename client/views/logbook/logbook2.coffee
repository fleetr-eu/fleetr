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
    cursor: Trips.find()
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
      field: 'start.time'
      sortable: true
      formatter: (row, cell, value, column, rowObject) ->
        "#{toTime(row,cell,rowObject.start.time)}<br />#{toTime(row, cell, rowObject.stop.time)}"
      width: 40
    ,
      id: 'beginEnd'
      name: 'Begin / End'
      formatter: (row, cell, value, column, rowObject) ->
        "#{rowObject.start.address}<br />#{rowObject.stop.address}"
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
    ,
      id: 'simpleMapLink'
      field: 'deviceId'
      name: 'Max Speed'
      width: 20
      align: 'center'
      formatter: (row, cell, value, column, rowObject) ->
        q = encodeURIComponent EJSON.stringify
          deviceId: value
          start:
            time: moment(rowObject.start.time).valueOf()
            position:
              lat: rowObject.start.lat
              lng: rowObject.start.lng
          stop:
            time: moment(rowObject.stop.time).valueOf()
            position:
              lat: rowObject.stop.lat
              lng: rowObject.stop.lng

        """
        <a href='/map/#{q}'>
          Map
        </a>
        """
    ]
    options:
      enableCellNavigation: false
      enableColumnReorder: false
      showHeaderRow: false
      explicitInitialization: true
      forceFitColumns: true
      rowHeight: 50
