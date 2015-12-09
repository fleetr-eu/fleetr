mapLinkFormatter = (row, cell, value) ->
  "<a href='/vehicles/map/#{value}'><img src='/images/Google-Maps-icon.png' height='22'}'></img></a>" 

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
    v = Vehicles.findOne(_id: Template.instance().data.vehicleId)
    v.name + " (" + v.licensePlate + ')'

# Tracker.autorun ->
#   console.log Session.get 'date'
Template.logbook2.helpers
  fleetrGridConfig: ->
    cursor: Trips.find()
    columns: [
      id: "date"
      field: "date"
      name: "Дата"
      width: 35
      sortable: true
      groupable:
        aggregators: aggregators
    ,
      id: 'fromTo'
      name: 'От / До'
      field: 'start.time'
      sortable: true
      formatter: (row, cell, value, column, rowObject) ->
        "#{toTime(row,cell,rowObject.start.time)}<br />#{toTime(row, cell, rowObject.stop.time)}"
      width: 35
    ,
      id: 'beginEnd'
      name: 'Старт / Финиш'
      formatter: (row, cell, value, column, rowObject) ->
        "#{rowObject.start.address}<br />#{rowObject.stop.address}"
      width: 80
      search: where: 'client'
    ,
      id: 'distance'
      field: 'distance'
      name: 'Разстояние'
      formatter: FleetrGrid.Formatters.roundFloat 2
      width: 20
      align: 'right'
      groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
    ,
      id: 'fuel'
      field: 'fuelConsumed'
      name: 'Гориво / на 100км'
      formatter: (row, cell, value, column, rowObject) ->
        fc = if rowObject.fuelConsumed then FleetrGrid.Formatters.roundFloat(2) row, cell, rowObject.fuelConsumed/1000 else ''
        fp100 = if rowObject.fuelPer100 then FleetrGrid.Formatters.roundFloat(2) row, cell, (rowObject.fuelPer100/rowObject.distance)/10 else ''
        "#{fc}<br />#{fp100}"
      width: 30
      align: 'right'
      groupTotalsFormatter: (totals, columnDef) ->
        val = totals.sum && totals.sum[columnDef.field];
        if val
          "<b>#{(Math.round(parseFloat(val)*100)/100)/1000}</b>"
        else ''
    ,
      id: 'speed'
      field: 'avgSpeed'
      name: 'Скорост / Макс'
      formatter: (row, cell, value, column, rowObject) ->
        s = if rowObject.avgSpeed then FleetrGrid.Formatters.roundFloat(2) row, cell, rowObject.avgSpeed else '' 
        ms = if rowObject.maxSpeed then FleetrGrid.Formatters.roundFloat(2) row, cell, rowObject.maxSpeed else ''
        "#{s}<br />#{ms}"
      width: 30
      cssClass: 'from'
      align: 'right'
    ,
      id: 'simpleMapLink'
      field: 'deviceId'
      name: 'М'
      maxWidth: 31
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
          <img src='/images/Google-Maps-icon.png' height='22'/>
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
