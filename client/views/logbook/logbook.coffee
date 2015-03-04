Template.logbook.created = ->
  @autorun -> Meteor.subscribe 'logbook', Session.get('logbook date filter')
  # Meteor.subscribe 'mycodes'

Template.logbook.rendered = ->
  $('#datepicker').datepicker
    autoclose: true
    todayHighlight: true

geocode2 = (lat,lon) ->
  scale = 1000
  lat = Math.round(lat*scale)
  lon = Math.round(lon*scale)

  code = MyCodes.findCachedLocationName lat, lon
  
  # console.log 'Found in cache: ' + lat + ':' + lon + ' found: ' + code
  
  if code
    return code.address
  
  geocoder = new google.maps.Geocoder();
  latlon = new google.maps.LatLng(lat/scale,lon/scale);


  geocoder.geocode { 'latLng': latlon}, (results, status) ->
    # console.log 'Location not found: ' + lat + ':' + lon
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
  opts: ->
   collection: Logbook
   rowsPerPage: 15
   fields: [
     { key: 'time', label: 'Time', fn: (val,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
     { key: 'address', label: 'Address', fn: (val,obj) -> geocode2(obj.lat,obj.lon) }
     # { key: 'type', label: 'Type' }
     { key: 'lat', label: 'Latitude' }
     { key: 'lon', label: 'Longitude' }
     { key: 'speed', label: 'Speed' }
     { key: 'course', label: 'Course' }
   ]
   showColumnToggles: true
   class: "table table-bordered table-hover"

Template.logbook.events
  'changeDate #datepicker': (event) ->
    args = Session.get('logbook date filter')?.time || {}
    args['$gte'] = event.date if event.target.name == 'start'
    args['$lte'] = moment(event.date).add(1, 'days').toDate() if event.target.name == 'end'
    Session.set 'logbook date filter', {time: args}
  'click #geocode': (event) ->
    console.log geocode2(55,83)
