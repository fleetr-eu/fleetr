TabularTables = {}

Meteor.isClient && Template.registerHelper('TabularTables', TabularTables)

TabularTables.LogbookAggByDate = new Tabular.Table
  name: "LogbookAggByDate"
  collection: AggByDate
  responsive:true
  columns: [
    { width: '10%', title: 'Date', data:'general()' }
    { title: 'From<br>To', data: 'fromTo()', className: 'time-col' }
    { width: '35%', title: 'Begin<br>End', data: 'beginEnd()'}
    { title: 'Distance', data:'distance()', className: 'distance-col' }
    { title: 'Fuel<br>Per 100', data:'fuel()', className: 'fuel-col' }
    { title: 'Speed<br>Max Speed', data:'speed()', className: 'speed-col' }
    { title: 'Travel Time<br>Idle Time', data: 'interval()', className: 'time-col' }
    { title: 'Details', tmpl: Meteor.isClient && Template.detailsCellTemplate }
    { title: 'Idle', tmpl: Meteor.isClient && Template.idleCellTemplate }
    # { width: '10%', title: 'Distance<br>Odometer', data:'distanceOdometer()', className: 'distance-col'}
    # { width: '10%', title: 'Speed<br>Max', data: 'speedMaxSpeed()', className: 'speed-col'}
    # { width: '10%', title: 'Duration', data:'duration()', className: 'time-col'}
    # { width: '10%', title: 'Fuel<br>per 100', data: 'fuel()', className: 'fuel-col'}
    # { width: '10%', title: 'Driver', data: 'driverName()' }
    # { width: '10%', tmpl: Meteor.isClient && Template.mapCellTemplate }
  ]
  extraFields: [
    'date', 'sumInterval', 'sumDistance', 'sumFuel',
    'startTime', 'stopTime',
    'startLat', 'stopLat', 'startLon', 'stopLon',
    'avgSpeed', 'maxSpeed', 'total',
    'startLocation', 'stopLocation',
    'idleTime'
  ]

TabularTables.LogbookStartStop = new Tabular.Table
  name: "LogbookStartStop"
  collection: StartStop
  responsive:true
  columns: [
    { width: '10%', title: 'Start<br>Finish', data:'startStop()' }
    { width: '35%', title: 'From<br>To', data: 'fromTo()' }
    { width: '10%', title: 'Distance<br>Odometer', data:'distanceOdometer()', className: 'distance-col'}
    { width: '10%', title: 'Speed<br>Max', data: 'speedMaxSpeed()', className: 'speed-col'}
    { width: '10%', title: 'Duration', data:'duration()', className: 'time-col'}
    { width: '10%', title: 'Fuel<br>per 100', data: 'fuel()', className: 'fuel-col'}
    { width: '10%', title: 'Driver', data: 'driverName()' }
    { width: '10%', tmpl: Meteor.isClient && Template.mapCellTemplate }
  ]

TabularTables.LogbookStartStopIdle = new Tabular.Table
  name: "LogbookStartStop"
  collection: StartStop
  responsive:true
  columns: [
    { width: '10%', title: 'Start<br>Finish', data:'startStop()' }
    { width: '35%', title: 'From<br>To', data: 'fromTo()' }
    { width: '10%', title: 'Distance<br>Odometer', data:'distanceOdometer()', className: 'distance-col'}
    { width: '10%', title: 'Speed<br>Max', data: 'speedMaxSpeed()', className: 'speed-col'}
    { width: '10%', title: 'Duration', data:'duration()', className: 'time-col'}
    { width: '10%', title: 'Fuel<br>per 100', data: 'fuel()', className: 'fuel-col'}
    { width: '10%', title: 'Driver', data: 'driverName()' }
    { width: '10%', tmpl: Meteor.isClient && Template.mapCellTemplate }
  ]

TabularTables.Drivers = new Tabular.Table
  name: "DriversList",
  collection: Drivers,
  columns: [
    {data: "firstName", title: "Name"},
    {data: "name", title: "Sirname"}
  ]
  createdRow: ( row, data, dataIndex ) ->
    if Meteor.isClient
      if Session.equals('selectedDriverId', data._id)
        $(row).addClass 'selected'
      else
        $(row).removeClass 'selected'

TabularTables.RecLog = new Tabular.Table
  name: "RecLog",
  collection: Logbook,
  columns: [
    {title: 'Time', data: 'recordTime', render: (val, type, doc) ->
      moment(val).zone(Settings.unitTimezone).format('DD-MM HH:mm:ss')
    }
    {title: 'Type', data: 'type'}
    {title: 'Event', data: 'event'}
    {title: 'Tacho', data: 'tacho'}
    {title: 'Distance', data: 'distance', render: (val, type, doc) -> val?.toFixed(3)}
    {title: 'Speed', data: 'speed', render: (val, type, doc) -> val?.toFixed(2)}
    {title: 'Calc Speed', data: 'speed', render: (val, type, doc) -> 
      return '' if not doc.interval
      (doc?.distance/1000/doc?.interval*3600)?.toFixed(2)
    }
    {title: 'Interval', data: 'interval'}
    {title: 'Offset', data: 'offset'}
    # {title: 'IO', data: 'io'}
  ]
  extraFields: ['io']
  rowCallback: (row,data)->
    # console.log 'Row: ' + row + ' data: ' + data.type
    rowClass = (item)->
      return 'regular-row' if item.type == 30
      return 'event-row' if item.type == 35
      if item.type == 29
        return if item.io%2 == 0 then 'stop-row' else 'start-row'
      'unknown'
    row.setAttribute('class', rowClass(data))
  # fnDrawCallback: gopage
  # console.log 'draw callback: ' +

TabularTables.IdleBook = new Tabular.Table
  name: "IdleBook"
  collection: IdleBook
  responsive:true
  columns: [
    { width: '10%', title: 'Date'     , data: 'idledate()' }
    { width: '10%', title: 'From'     , data: 'from()', className: 'time-col' }
    { width: '10%', title: 'To'       , data: 'to()', className: 'time-col' }
    { width: '35%', title: 'Address'  , data: 'address()' }
    { width: '10%', title: 'Duration' , data: 'dur()', className: 'time-col' }
    { width: '10%', title: 'Distance' , data: 'passedDistance()', className: 'distance-col' }
    {width: '10%', title: 'Details', tmpl: Meteor.isClient && Template.idleDetailsCellTemplate }
  
    # { width: '10%', tmpl: Meteor.isClient && Template.mapCellTemplate }
  ]
