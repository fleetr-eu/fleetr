unitId = null
Template.simpleMap.onCreated ->
  {deviceId} =  EJSON.parse decodeURIComponent @data
  unitId = deviceId

Template.simpleMap.onRendered ->
  mapCanvasHeight = $(document).height() - 150
  $('#simpleMap').height mapCanvasHeight
  {deviceId, start, stop, idle} =  EJSON.parse decodeURIComponent @data
  start.time = moment(start.time).toDate()
  stop.time = moment(stop.time).toDate()
  map = new google.maps.Map document.getElementById("simpleMap"), Map.options
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

    Meteor.subscribe 'logbook', searchArgs, ->
      path = Logbook.find(searchArgs, {sort: recordTime: -1}).map (point) ->
        color = if point.speed >= Settings.maxSpeed then 'red' else 'blue'
        if color
          opts =
            position: new google.maps.LatLng(point.lat, point.lon)
            icon: "/images/icons/#{color}-circle.png"
            map: map
          info =
            speed: point.speed?.toFixed(0)
            distance: (point.tacho/1000)?.toFixed(0)
          new InfoMarker opts, info

        lat: point.lat, lng: point.lon, id: point._id

      new FleetrPolyline map, _.filter(path, (p) -> !(isNaN(p.lat) || isNaN(p.lng)))

Template.simpleMap.helpers
  unitId: -> unitId
