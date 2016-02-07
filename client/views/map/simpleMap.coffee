unitId = null
Template.simpleMap.onCreated ->
  {deviceId} =  EJSON.parse decodeURIComponent @data
  unitId = deviceId
  Session.set 'simpleMapShowInfoMarkers', false

Template.simpleMap.onRendered ->
  {deviceId, start, stop, idle} =  EJSON.parse decodeURIComponent @data
  start.time = moment(start.time).toDate()
  stop.time = moment(stop.time).toDate()
  map = @map = new google.maps.Map document.getElementById("simpleMap"), Map.options
  showMarkersCheckbox = document.getElementById("show-info-markers")
  map.controls[google.maps.ControlPosition.TOP_LEFT].push showMarkersCheckbox

  if idle
    searchArgs =
      startTime: start.time
      stopTime: stop.time
      deviceId: deviceId
    Meteor.subscribe 'idlebook', searchArgs, ->
      idleRec = IdleBook.findOne searchArgs
      if idleRec
        lat = idleRec.latitude || idleRec.lat || idleRec.location?.latitude
        lng = idleRec.longitude || idleRec.lon || idleRec.location?.longitude
        pos = new google.maps.LatLng(lat, lng)
        map.panTo pos
        new google.maps.Marker
          map: map
          position: pos
          icon: '/images/truck-blue.png'
  else
    bounds = new google.maps.LatLngBounds()
    [_.extend(start, {title: 'Start', icon: '/images/icons/start.png'}),
    _.extend(stop, {title: 'Stop', icon: '/images/icons/finish.png'})].forEach (point) ->
      new google.maps.Marker _.extend(point, {map: map})
      bounds.extend new google.maps.LatLng(point.position.lat, point.position.lng)
    map.fitBounds bounds

    searchArgs =
      recordTime:
        $gte: start.time
        $lte: stop.time
      deviceId: deviceId
      type: $ne: 35

    @autorun =>
      Meteor.subscribe 'logbook', searchArgs, =>
        path = @path = Logbook.find(searchArgs, {sort: recordTime: -1}).map (point) ->
          lat: point.lat, lng: point.lon, id: point._id, data: point
        pointsWithLocation = (p) -> !(isNaN(p.lat) || isNaN(p.lng))
        new FleetrPolyline map, _.filter(path, pointsWithLocation)

Template.simpleMap.events
  'change #show-info-markers-check': (e) ->
    Session.set 'simpleMapShowInfoMarkers', e.target.checked

Template.simpleMap.helpers
  unitId: -> unitId
  showInfoMarkers: ->
    t = Template.instance()
    if Session.get('simpleMapShowInfoMarkers')
      if t.markers
        m.setMap t.map for m in t.markers
      else
        t.markers = []
        t.path?.map (p) ->
          point = p.data
          color = if point.speed >= Settings.maxSpeed then 'red' else 'blue'
          opts =
            position: new google.maps.LatLng(point.lat, point.lon)
            icon: "/images/icons/#{color}-circle.png"
            map: t.map
          info =
            speed: point.speed?.toFixed(0)
            distance: (point.tacho/1000)?.toFixed(0)
          t.markers.push new InfoMarker opts, info
    else
      m.setMap(null) for m in t.markers if t.markers
    !!Session.get('simpleMapShowInfoMarkers')
