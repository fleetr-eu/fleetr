@DateRangeAggregation = new Mongo.Collection 'dateRangeAggregation'
@StartStop = new Mongo.Collection 'startstop'

LOGBOOK_FILTER_NAME   = 'logbook-filter'
STARTSTOP_FILTER_NAME = 'logbook-startstop-filter'

MESSAGE_ROW_TYPE  = 0
START_STOP_ROW_TYPE  = 29
REGULAR_ROW_TYPE  = 30
EVENT_ROW_TYPE    = 35

UNIT_TIMEZONE = '+0200' # should be configured probably in vehicle configuration

twin = (str1,str2) ->
  new Spacebars.SafeString(str1 + '<br>' + str2)


createAggregationTableOptions = ->
  collection: DateRangeAggregation
  rowsPerPage: 10
  fields: [
    { key: '_id', label: 'Date'}
    # { key: 'total', label: 'Amount' }
    # { key: 'minSpeed', label: 'Min speed'}
    { key: 'loc', label: 'From/To', fn: (val,obj)->
      start = obj.startLat.toFixed(2) + ':' + obj.startLon.toFixed(2)
      stop = obj.stopLat.toFixed(2) + ':' + obj.stopLon.toFixed(2)
      startLocation = geocode2(30, obj.startLat, obj.startLon).split(',')[-3..]
      stopLocation = geocode2(30, obj.stopLat, obj.stopLon).split(',')[-3..]
      twin(startLocation,stopLocation)

    }
    { key: 'distance', label: 'Distance/Odo', fn: (val,obj)->
      km = Math.floor(obj.lastOdometer/1000)
      m = obj.lastOdometer%1000
      odo = km + ',' + m
      twin((obj.sumDistance/1000).toFixed(0),odo)
    }

    # { key: 'maxSpeed', label: 'Max speed (km/h)', fn: (val)->(val).toFixed(0) }
    # { key: 'avgSpeed', label: 'Avg speed (km/h)', fn: (val)->(val).toFixed(0) }
    { key: 'speed', label: 'Speed/Max', fn: (val,obj)-> twin(obj.avgSpeed?.toFixed(0),obj.maxSpeed?.toFixed(0)) }
    { key: 'time', label: 'Time/Idle', fn: (val,obj)->
      move = moment.duration(obj.sumMoveInterval, "seconds").format('HH:mm:ss', {trim: false})
      idle = moment.duration(obj.sumIdleInterval, "seconds").format('HH:mm:ss', {trim: false})
      twin(move,idle)
      # diff = moment(obj.stopTime).diff(moment(obj.startTime), 'seconds')
      # moment.duration(diff, "seconds").format('HH:mm:ss', {trim: false})
    }

    # { key: 'sumFuel', label: 'Fuel (l)', fn: (val)-> (val/1000).toFixed(2) }
    # { key:'litersPer100', label: 'Fuel (l/100km)', fn: (val,obj)->(obj.sumFuel/obj.sumDistance*100).toFixed(2) }
    { key:'litersPer100', label: 'Fuel/Per 100', fn: (val,obj)->
      f = (obj.sumFuel/1000).toFixed(2)
      fl = (obj.sumFuel/obj.sumDistance*100).toFixed(2)
      twin(f,fl)}

    # { key:'kmPerLiter', label: 'Fuel (km/l)', fn: (val,obj)->(obj.sumDistance/obj.sumFuel).toFixed(2) }
    # { key:'test', label: 'Test', fn: (val,obj)-> 1000.toFixed(2) }
    {key: 'map', label: 'Map', tmpl: Template.aggMapCellTemplate}
  ]
  showColumnToggles: true
  class: "table table-stripped aggregation-table"

Template.mapCellTemplate.helpers
  opts: -> encodeURIComponent EJSON.stringify
    deviceId: @start.deviceId
    start:
      time: moment(@start.recordTime).valueOf()
      position:
        lat: @start.lat
        lng: @start.lon
    stop:
      time: moment(@stop.recordTime).valueOf()
      position:
        lat: @stop.lat
        lng: @stop.lon

Template.logbook.created = ->
  @TabularTables = {}
  @autorun ->
    # Meteor.subscribe 'logbook', Session.get(LOGBOOK_FILTER_NAME)
    Meteor.subscribe 'dateRangeAggregation', Session.get(LOGBOOK_FILTER_NAME)
    Meteor.subscribe 'startstoppub', Session.get(STARTSTOP_FILTER_NAME)
  Template.registerHelper('TabularTables', @TabularTables)
  # @TabularTables.Logbook = createLogbookTable()

Template.logbook.rendered = ->

  drp = '<label>Period:<input type="text" id="daterange" class="form-control input-sm"/>  </label> '
  $("#aggregated-table-section").find("#datatable_length").parent().removeClass("col-sm-6")
  $("#aggregated-table-section").find("#datatable_filter").parent().removeClass("col-sm-6")
  $("#aggregated-table-section").find("#datatable_length").parent().addClass("col-sm-4")
  $("#aggregated-table-section").find("#datatable_filter").parent().addClass("col-sm-8")
  $("#aggregated-table-section").find("#datatable_filter").prepend(drp)

  sp = '<label>Speed:<input type="text" id="speed" class="form-control input-sm"/>  </label>
        <label>Hide Idle <input id="hideIdleCheckbox" type="checkbox" class="form-control hide-idle" />&nbsp;&nbsp;</label>'
  $("#detailed-table-section").find("#datatable_length").parent().removeClass("col-sm-6")
  $("#detailed-table-section").find("#datatable_filter").parent().removeClass("col-sm-6")
  $("#detailed-table-section").find("#datatable_length").parent().addClass("col-sm-4")
  $("#detailed-table-section").find("#datatable_filter").parent().addClass("col-sm-8")
  $("#detailed-table-section").find("#datatable_filter").prepend(sp)


  $('#daterange').daterangepicker
    locale: {cancelLabel: 'Clear'}
    ranges:
      'Today': [moment(), moment()]
      'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')]
      'Last 7 Days': [moment().subtract(6, 'days'), moment()]
      'Last 30 Days': [moment().subtract(29, 'days'), moment()]
      'This Month': [moment().startOf('month'), moment().endOf('month')]
      'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]

geocode2 = (type, lat,lon) ->
  return "" if type == MESSAGE_ROW_TYPE
  scale = 1000
  lat = Math.round(lat*scale)
  lon = Math.round(lon*scale)

  code = MyCodes.findCachedLocationName lat, lon

  if code
    return code.address

  geocoder = new google.maps.Geocoder();
  latlon = new google.maps.LatLng(lat/scale,lon/scale);


  geocoder.geocode { 'latLng': latlon}, (results, status) ->
    if status isnt google.maps.GeocoderStatus.OK
      console.log 'Geocode error: ' + lat + ':' + lon + ': ' +  status
      return
    if not results[0]
      console.log 'Geocode error: ' + lat + ':' + lon + ': ' + JSON.strinfify(results)
      return
    address = results[0].formatted_address
    console.log 'Geocoded: ' + lat + ':' + lon + ': ' + address
    Meteor.call 'cacheLocationName',  lat, lon, address

  'loading...'


aggOptions =
  responsive:true
  columns: [
    {data: '_id', title: 'Date'}
    {title: 'From/To', data: (obj)->
      start = obj.startLat.toFixed(2) + ':' + obj.startLon.toFixed(2)
      stop = obj.stopLat.toFixed(2) + ':' + obj.stopLon.toFixed(2)
      startLocation = geocode2(30, obj.startLat, obj.startLon).split(',')[-3..]
      stopLocation = geocode2(30, obj.stopLat, obj.stopLon).split(',')[-3..]
      twin(startLocation,stopLocation)
    }
    {title: 'Distance/Odo', className: 'distance-col', data: (obj)->
      km = Math.floor(obj.lastOdometer/1000)
      m = obj.lastOdometer%1000
      odo = km + ',' + m
      twin((obj.sumDistance/1000).toFixed(0),odo)
    }
    {title: 'Speed/Max', className: 'speed-col', data: (obj)-> twin(obj.avgSpeed?.toFixed(0),obj.maxSpeed?.toFixed(0)) }
    {title: 'Time/Idle', className: 'time-col', data: (obj)->
      move = moment.duration(obj.sumMoveInterval, "seconds").format('HH:mm:ss', {trim: false})
      idle = moment.duration(obj.sumIdleInterval, "seconds").format('HH:mm:ss', {trim: false})
      twin(move,idle)
    }
    {title: 'Fuel/Per 100', className: 'fuel-col', data: (obj)->
      f = (obj.sumFuel/1000).toFixed(2)
      fl = (obj.sumFuel/obj.sumDistance*100).toFixed(2)
      twin(f,fl)
    }

    {title: 'Map', tmpl: Template.aggMapCellTemplate}
  ]

startStopOptions =
  responsive:true
  columns: [
    {title: 'Start/Finish', className: '', data: (obj)->
      start = moment(obj.start.recordTime).zone(UNIT_TIMEZONE).format('HH:mm:ss')
      stop = moment(obj.stop.recordTime).zone(UNIT_TIMEZONE).format('HH:mm:ss')
      twin(start,stop)
    }
    {title: 'From/To', className: '', data: (obj)->
      startLocation = geocode2(obj.start.type, obj.start.lat, obj.start.lon).split(',')[-3..]
      stopLocation = geocode2(obj.stop.type, obj.stop.lat, obj.stop.lon).split(',')[-3..]
      twin(startLocation,stopLocation)
    }
    {title: 'Distance/Odo', className: 'distance-col', data: (obj)->
      km = Math.floor(obj.stop.tacho/1000)
      m = obj.stop.tacho%1000
      odo = km + ',' + m
      twin(obj.startStopDistance.toFixed(2), odo)
    }
    {title: 'Speed/Max', className: 'speed-col', data: (obj)-> twin(obj.startStopSpeed?.toFixed(0),obj.maxSpeed?.toFixed(0)) }
    {title: 'Travel time', className: 'time-col', data: (obj)->
      diff = moment(obj.stop.recordTime).diff(moment(obj.start.recordTime), 'seconds')
      moment.duration(diff, "seconds").format('HH:mm:ss', {trim: false})
    }
    {title: 'Fuel/Per 100', className: 'fuel-col', data: (obj)->
      distance = (obj.stop.tacho-obj.start.tacho)/1000
      fuel = (obj.stop.fuelc-obj.start.fuelc)/1000
      twin(fuel.toFixed(2) + ' (l)', (fuel/distance*100).toFixed(2) + ' (l/100km)')
    }
    {title: 'Driver', className: '', data: (obj)->
      # vehicle = Vehicles.find ({unitId: obj.deviceId})
      # console.log 'Vehicle: ' + JSON.stringify(vehicle) if vehicle
      # driverId = Vehicles.getAssignedDriver(vehicle._id, Date.now())
      # console.log 'driverid: ' + driverId
      # driver = Drivers.findOne({_id: driverId})
      # console.log 'driver: ' + driver
      # console.log 'Driver: ' + JSON.stringify(driver) if driver
      twin('&lt;driver&gt;','&lt;license&gt;')
    }
    {title: 'Map', className: '', tmpl: Template.mapCellTemplate}
  ]


Template.logbook.helpers
  selector: ()-> Session.get(LOGBOOK_FILTER_NAME)
  #filter: ()-> JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
  aggopts: createAggregationTableOptions
  # startstopopts: createStartStopOptions
  hideIdle: () -> Session.get(STARTSTOP_FILTER_NAME)?.hideIdle


  aggDatafunc: ()->
    () -> DateRangeAggregation.find().fetch()
  aggOptions: aggOptions

  startStopDatafunc: ()->
    () -> StartStop.find().fetch()
  startStopOptions: startStopOptions


show = (obj) ->
  str = ''
  for p of obj
    if obj.hasOwnProperty(p)
      str += p + '::' + obj[p] + '\n'
  return str


Template.logbook.events
  'cancel.daterangepicker #daterange': (event,p) ->
    $('#daterange').val('')
    filter = Session.get(LOGBOOK_FILTER_NAME) || {}
    delete filter.recordTime
    $("#speed").val('')
    $(".agg-table tr").removeClass('selected')
    Session.set LOGBOOK_FILTER_NAME, filter
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(filter)
  'apply.daterangepicker #daterange': (event,p) ->
    startDate = $('#daterange').data('daterangepicker').startDate
    endDate = $('#daterange').data('daterangepicker').endDate
    console.log startDate.format('YYYY-MM-DD') + ' - ' + endDate.format('YYYY-MM-DD')
    args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
    args['$gte'] = startDate.toDate()
    $("#speed").val('')
    # args['$lte'] = endDate.add(1, 'days').toDate()
    args['$lte'] = endDate.toDate()
    Session.set LOGBOOK_FILTER_NAME, {recordTime: args}
    Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
    # console.log 'logbook date filter: ' + JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
  'change #speed': (event,p) ->
    console.log 'Speed: ' + event.target.value
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    speed = Number(event.target.value)
    filter.speed = speed
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)
  'click .agg-table tr': (event,p)->
    value = $('td', event.currentTarget).eq(0).text()
    console.log 'Click: ' + value
    # name = $('td', this).eq(0).text()
    startDate = moment(value)
    endDate = moment(value).add(1, 'days')
    args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
    args['$gte'] = startDate.toDate()
    args['$lte'] = endDate.toDate()
    $("#speed").val('')
    # console.log 'Filter: ' + JSON.stringify(args)
    Session.set STARTSTOP_FILTER_NAME, {recordTime: args}
    $(".aggregation-table tr").removeClass('selected')
    event.currentTarget.setAttribute('class', 'selected')

  'click #hideIdleCheckbox': (event,p)->
    filter = Session.get(STARTSTOP_FILTER_NAME) || {}
    console.log 'Clicked: ' + event.target.checked
    filter.hideIdle = event.target.checked
    Session.set STARTSTOP_FILTER_NAME, filter
    # console.log 'Filter: ' + JSON.stringify(args)
