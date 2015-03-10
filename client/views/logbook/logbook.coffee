@DateRangeAggregation = new Mongo.Collection 'dateRangeAggregation'


MESSAGE_ROW_TYPE  = 0
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
      {data: "type", title: "Type"}
      {data: 'address', title: 'Location', render: (val,type,obj) -> geocode2(obj.type, obj.lat,obj.lon) }
      {data: "speed", title: "Speed"}
      {data: 'tacho', title: 'Odometer(km)', render: (val,type,obj) -> val/1000 } 
      {data: 'fuell', title: 'Fuel'}  #, fn: (val,obj) -> val/1000 } }
      {data: 'fuelc', title: 'Fuel Consumed(l)', render: (val,type,obj) -> val/1000 }
      {title: 'Driver', render: (val,type,obj) -> '&lt;driver&gt;' }
      {title: 'License', render: (val,type,obj) -> '&lt;license&gt;' }
      {title: 'Map', render: (val,type,obj) -> '&lt;map link&gt;' }
      {data: "lat", title: "Lat", visible: false}
      {data: "lon", title: "Lon", visible: false}

    ]
    # selector: () -> {type:30}
  console.log 'Table defined'



  @autorun -> 
    Meteor.subscribe 'logbook', Session.get('logbook date filter')
    Meteor.subscribe 'dateRangeAggregation', Session.get('logbook date filter')



Template.logbook.rendered = ->
  $('#daterange').daterangepicker()
  # $('#datepicker').datepicker
  #   autoclose: true
  #   todayHighlight: true

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
  selector: ()-> Session.get('logbook date filter')
  aggopts: ->
    collection: DateRangeAggregation
    rowsPerPage: 15
    fields: [
      { key: '_id', label: 'Date'}
      { key: 'total', label: 'Amount' }
      { key: 'minSpeed', label: 'Min speed'}
      { key: 'maxSpeed', label: 'Max speed'}
      { key: 'avgSpeed', label: 'Avg speed'}
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
  #   args = Session.get('logbook date filter')?.recordTime || {}
  #   args['$gte'] = event.date if event.target.name == 'start'
  #   args['$lte'] = moment(event.date).add(1, 'days').toDate() if event.target.name == 'end'
  #   Session.set 'logbook date filter', {recordTime: args}
  #   console.log 'logbook date filter: ' + JSON.stringify({recordTime: args})
  'apply.daterangepicker #daterange': (event,p) ->
    startDate = $('#daterange').data('daterangepicker').startDate
    endDate = $('#daterange').data('daterangepicker').endDate
    console.log startDate.format('YYYY-MM-DD') + ' - ' + endDate.format('YYYY-MM-DD')
    args = Session.get('logbook date filter')?.recordTime || {}
    args['$gte'] = startDate.toDate() 
    # args['$lte'] = endDate.add(1, 'days').toDate()
    args['$lte'] = endDate.toDate()
    #console.log 'logbook date filter: ' + JSON.stringify(args)
    Session.set 'logbook date filter', {recordTime: args}
