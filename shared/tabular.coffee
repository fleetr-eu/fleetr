TabularTables = {}

Meteor.isClient && Template.registerHelper('TabularTables', TabularTables)

languageTt = {
  "sProcessing":   "Обработка на резултатите...",
  "sLengthMenu":   "Показване на _MENU_ резултата",
  "sZeroRecords":  "Няма намерени резултати",
  "sInfo":         "Показване на резултати от _START_ до _END_ от общо _TOTAL_",
  "sInfoEmpty":    "Показване на резултати от 0 до 0 от общо 0",
  "sInfoFiltered": "(филтрирани от общо _MAX_ резултата)",
  "sInfoPostFix":  "",
  "sSearch":       "Търсене във всички колони:",
  "sUrl":          "",
  "oPaginate": {
    "sFirst":    "Първа",
    "sPrevious": "Предишна",
    "sNext":     "Следваща",
    "sLast":     "Последна"
  }
}

TabularTables.LogbookAggByDate = new Tabular.Table
  name: "LogbookAggByDate"
  collection: AggByDate
 # lengthChange: false
  responsive:true
  searching: false
  language: languageTt
  columns: [
    # { width: '10%', title: 'Date', data:'general()' }
    { width: '10%', title: 'Date', data:'date', render: (val, type, doc) -> doc.general() }
    { title: 'From<br>To', data: 'fromTo()', className: 'time-col' }
    { width: '35%', title: 'Begin<br>End', data: 'startAddress', render: (val, type, doc) -> doc.beginEnd() }
    { title: 'Distance', data:'sumDistance', className: 'distance-col', render: (val, type, doc) -> doc.distance() }
    { title: 'Fuel<br>Per 100', data:'sumFuel', className: 'fuel-col', render: (val, type, doc) -> doc.fuel() }
    { title: 'Speed<br>Max Speed', data:'maxSpeed', className: 'speed-col', render: (val, type, doc) -> doc.speed() }
    { title: 'Travel Time', data: 'sumInterval', className: 'time-col', render: (val, type, doc) -> doc.interval() }
    { title: 'Details', tmpl: Meteor.isClient && Template.detailsCellTemplate }
    { title: 'Idle', tmpl: Meteor.isClient && Template.idleCellTemplate }
    # hidden columns, only for searching
    { data: 'stopAddress', className: 'hidden' }
  ]
  # pub: "aggbydate-tabular"
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
  language: languageTt
  responsive:true
  searching: false
  columns: [
    { width: '10%', title: 'Start<br>Finish', data:'start.recordTime', render: (val, type, doc) -> doc.startStop() }
    { width: '35%', title: 'From<br>To', data: 'startAddress', render: (val, type, doc) -> doc.fromTo() }
    { width: '10%', title: 'Distance<br>Odometer', data:'startStopDistance', className: 'distance-col', render: (val, type, doc) -> doc.distanceOdometer() }
    { width: '10%', title: 'Speed<br>Max', data: 'startStopSpeed', className: 'speed-col', render: (val, type, doc) -> doc.speedMaxSpeed() }
    { width: '10%', title: 'Duration', data: 'interval', className: 'time-col', render: (val, type, doc) -> doc.duration() }
    { width: '10%', title: 'Fuel<br>per 100', data: 'fuelUsed', className: 'fuel-col', render: (val, type, doc) -> doc.fuel() }
    { width: '10%', title: 'Driver', data: 'driverName()' }
    { width: '10%', tmpl: Meteor.isClient && Template.mapCellTemplate }
  ]
  extraFields: [
    'start', 'stop', 'startStopDistance', 'startStopSpeed', 'maxSpeed'
  ]    

TabularTables.Drivers = new Tabular.Table
  name: "DriversList"
  collection: Drivers
  language: languageTt
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
  name: "RecLog"
  collection: Logbook
  language: languageTt
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
    rowClass = (item)->
      return 'regular-row' if item.type == 30
      return 'event-row' if item.type == 35
      if item.type == 29
        return if item.io%2 == 0 then 'stop-row' else 'start-row'
      'unknown'
    row.setAttribute('class', rowClass(data))

TabularTables.IdleBook = new Tabular.Table
  name: "IdleBook"
  collection: IdleBook
  language: languageTt
  responsive:true
  columns: [
    { width: '10%', title: 'Date'     , data: 'idledate()' }
    { width: '10%', title: 'From'     , data: 'from()', className: 'time-col' }
    { width: '10%', title: 'To'       , data: 'to()', className: 'time-col' }
    { width: '50%', title: 'Address'  , data: 'address()' }
    { width: '10%', title: 'Duration' , data: 'dur()', className: 'time-col' }
    { width: '10%', title: 'Distance' , data: 'passedDistance()', className: 'distance-col' }
    { width: '10%', title: 'Driver', data: 'driverName()' }
    # { width: '10%', title: 'Details'   , tmpl: Meteor.isClient && Template.idleDetailsCellTemplate }
    { width: '5%', tmpl: Meteor.isClient && Template.mapIdleCellTemplate }
  ]
