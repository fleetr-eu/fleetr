@DateRangeAggregation = new Mongo.Collection 'dateRangeAggregation'
@StartStop = new Mongo.Collection 'startstop'

LOGBOOK_FILTER_NAME = 'logbook-filter'

MESSAGE_ROW_TYPE  = 0
START_STOP_ROW_TYPE  = 29
REGULAR_ROW_TYPE  = 30
EVENT_ROW_TYPE    = 35


rowStyles =
  0: 'message-row'
  30: 'regular-row'
  29: 'start-row'
  35: 'event-row'
  'unknown' : 'unknown-row'

Template.logbook.created = ->
  @TabularTables = {}
  Template.registerHelper('TabularTables', @TabularTables)
  

  # Meteor.isClient && Template.registerHelper('TabularTables', TabularTables)

  @TabularTables.Logbook = new Tabular.Table 
    name: "Logbook"
    collection: Logbook
    columns: [
      {data: 'recordTime', label: 'Time', render: (val,type,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
      {data: 'io', label: 'Start/Stop', render: (val,type,obj) -> 
        return '' if obj.type != START_STOP_ROW_TYPE
        if val%2==0 then 'stop' else 'start'
        #val + ' ' + mark 
      }
      {data: "type", title: "Type"}
      {data: 'address', title: 'Location', render: (val,type,obj) -> geocode2(obj.type, obj.lat,obj.lon) }
      {data: "speed", title: "Speed (km/h)", render: (val,type,obj) -> val }
      {data: 'distance', title: 'Distance (m)', render: (val,type,obj) -> val} 
      {data: 'fuelUsed', title: 'Fuel (ml)', render: (val,type,obj) -> val }
      {data: 'fuell', title: 'Fuel (l)'}  #, fn: (val,obj) -> val/1000 } }
      {title: 'Driver', render: (val,type,obj) -> '&lt;driver&gt;' }
      {title: 'License', render: (val,type,obj) -> '&lt;license&gt;' }
      {title: 'Map', render: (val,type,obj) -> '&lt;map link&gt;' }
      {data: "lat", title: "Lat", visible: false}
      {data: "lon", title: "Lon", visible: false}

    ]
    # selector: () -> {type:30}
  console.log 'Table defined'



  @autorun -> 
    #Session.set(LOGBOOK_FILTER_NAME, {type:29})
    Meteor.subscribe 'logbook', Session.get(LOGBOOK_FILTER_NAME)
    Meteor.subscribe 'dateRangeAggregation', Session.get(LOGBOOK_FILTER_NAME)
    Meteor.subscribe 'startstoppub', Session.get(LOGBOOK_FILTER_NAME)


Template.logbook.rendered = ->
  $('#daterange').daterangepicker()
  # $('#datepicker').datepicker
  #   autoclose: true
  #   todayHighlight: true

twin = (str1,str2) ->
  new Spacebars.SafeString(str1 + '<br>' + str2)

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


Template.logbook.helpers
  selector: ()-> Session.get(LOGBOOK_FILTER_NAME)
  #filter: ()-> JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
  aggopts: ->
    collection: DateRangeAggregation
    rowsPerPage: 15
    fields: [
      { key: '_id', label: 'Date'}
      # { key: 'total', label: 'Amount' }
      # { key: 'minSpeed', label: 'Min speed'}
      { key: 'maxSpeed', label: 'Max speed (km/h)', fn: (val)->(val).toFixed(0) }
      { key: 'avgSpeed', label: 'Avg speed (km/h)', fn: (val)->(val).toFixed(0) }
      { key: 'sumDistance', label: 'Distance (km)', fn: (val)->(val/1000).toFixed(0) }
      { key: 'sumFuel', label: 'Fuel (l)', fn: (val)-> (val/1000).toFixed(2) }
      { key:'litersPer100', label: 'Fuel (l/100km)', fn: (val,obj)->(obj.sumFuel/obj.sumDistance*100).toFixed(2) }
      { key:'kmPerLiter', label: 'Fuel (km/l)', fn: (val,obj)->(obj.sumDistance/obj.sumFuel).toFixed(2) }
      # { key:'test', label: 'Test', fn: (val,obj)-> 1000.toFixed(2) }
    ]
    showColumnToggles: true
    class: "table table-bordered table-hover"
  startstopopts: ->
    collection: StartStop
    rowsPerPage: 15
    fields: [
      # { key: '_id', label: 'Date'}
      # { key: 'total', label: 'Amount' }
      # { key: 'minSpeed', label: 'Min speed'}
      {key: 'startStopTime', label: 'Time', fn: (val,obj)-> twin(moment(obj.start.recordTime).format('DD/MM/YYYY HH:mm'), moment(obj.stop.recordTime).format('DD/MM/YYYY HH:mm'))}
      {key: 'startStopLocation', label: 'Location', fn: (val,obj)-> 
        startLocation = geocode2(obj.start.type, obj.start.lat, obj.start.lon).split(',')[-3..]
        stopLocation = geocode2(obj.stop.type, obj.stop.lat, obj.stop.lon).split(',')[-3..]
        twin(startLocation,stopLocation)
      }
      {key: 'startStopDistance', label: 'Distance (km)', fn: (val,obj)-> ((obj.stop.tacho-obj.start.tacho)/1000).toFixed(2)}
      {key: 'startStopTravelTime', label: 'Travel time', fn: (val,obj)-> 
        diff = moment(obj.stop.recordTime).diff(moment(obj.start.recordTime), 'seconds')
        moment.duration(diff, "seconds").format('HH:mm:ss', {trim: false})
      }
      {key: 'startStopSpeed', label: 'Speed (km/h)', fn: (val,obj)-> 
        distance = (obj.stop.tacho-obj.start.tacho)/1000
        seconds = moment(obj.stop.recordTime).diff(moment(obj.start.recordTime), 'seconds')
        (distance*3600/seconds).toFixed(0)
      }
      {key: 'startStopFuel', label: 'Fuel', fn: (val,obj)-> 
        distance = (obj.stop.tacho-obj.start.tacho)/1000
        fuel = (obj.stop.fuelc-obj.start.fuelc)/1000
        twin(fuel.toFixed(2) + ' (l)', (fuel/distance*100).toFixed(2) + ' (l/100km)')
      }
      {key: 'driver', label: 'Driver', fn: (val)->twin('&lt;driver&gt;','&lt;license&gt;') }
      # {key: 'license', label: 'License', fn: (val)->'<license>' }
      {key: 'vehicle', label: 'Vehicle', fn: (val)->'<vehicle>' }
      {key: 'map', label: 'Map', fn: (val)->'<map link>' }
      # { key: 'sumDistance', label: 'Distance (km)', fn: (val)->(val/1000).toFixed(0) }
      # { key: 'sumFuel', label: 'Fuel (l)', fn: (val)-> (val/1000).toFixed(2) }
      # { key:'litersPer100', label: 'Fuel (l/100km)', fn: (val,obj)->(obj.sumFuel/obj.sumDistance*100).toFixed(2) }
      # { key:'kmPerLiter', label: 'Fuel (km/l)', fn: (val,obj)->(obj.sumDistance/obj.sumFuel).toFixed(2) }
      # { key:'test', label: 'Test', fn: (val,obj)-> 1000.toFixed(2) }
    ]
    showColumnToggles: true
    class: "table table-bordered table-hover"
  # opts: ->
  #   collection: Logbook
  #   rowsPerPage: 15
  #   fields: [
  #     { key: 'recordTime', label: 'Time', fn: (val,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
  #     { key: 'type', label: 'Type' }
  #     { key: 'address', label: 'Location', fn: (val,obj) -> geocode2(obj.type, obj.lat,obj.lon) }
  #     # { key: 'lat', label: 'Latitude' }
  #     # { key: 'lon', label: 'Longitude' }
  #     # { key: 'speed2', label: 'Speed2' }
  #     { key: 'speed', label: 'Speed' }
  #     { key: 'tacho', label: 'Odometer(km)', fn: (val,obj) -> val/1000 } 
  #     { key: 'fuell', label: 'Fuel'}  #, fn: (val,obj) -> val/1000 } }
  #     { key: 'fuelc', label: 'Fuel Consumed(l)', fn: (val,obj) -> val/1000 }
  #     # { key: 'course', label: 'Course' }
  #   ]
  #   showColumnToggles: true
  #   class: "table table-bordered table-hover"
  #   rowClass: (item) ->
  #     style = rowStyles[item.type]
  #     style = rowStyles['unknown'] if not style
  #     style
     
  




Template.logbook.events
  # 'changeDate #datepicker': (event) ->
  #   args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
  #   args['$gte'] = event.date if event.target.name == 'start'
  #   args['$lte'] = moment(event.date).add(1, 'days').toDate() if event.target.name == 'end'
  #   Session.set LOGBOOK_FILTER_NAME, {recordTime: args}
  #   console.log 'logbook date filter: ' + JSON.stringify({recordTime: args})
  'apply.daterangepicker #daterange': (event,p) ->
    startDate = $('#daterange').data('daterangepicker').startDate
    endDate = $('#daterange').data('daterangepicker').endDate
    console.log startDate.format('YYYY-MM-DD') + ' - ' + endDate.format('YYYY-MM-DD')
    args = Session.get(LOGBOOK_FILTER_NAME)?.recordTime || {}
    args['$gte'] = startDate.toDate() 
    # args['$lte'] = endDate.add(1, 'days').toDate()
    args['$lte'] = endDate.toDate()
    Session.set LOGBOOK_FILTER_NAME, {recordTime: args}
    console.log 'logbook date filter: ' + JSON.stringify(Session.get(LOGBOOK_FILTER_NAME))
  'change #speed': (event,p) ->
    console.log 'Speed: ' + event.target.value
    args = Session.get(LOGBOOK_FILTER_NAME)?.speed || {}   
    args['speed'] = event.target.value
    console.log 'Filter: ' + JSON.stringify(args)