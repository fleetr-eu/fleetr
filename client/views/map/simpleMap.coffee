Template.simpleMap.rendered = ->
  {deviceId, start, stop} =  EJSON.parse decodeURIComponent @data
  start.time = moment(start.time).toDate()
  stop.time = moment(stop.time).toDate()
  map = new google.maps.Map document.getElementById("simpleMap"), Map.options
  bounds = new google.maps.LatLngBounds()
  [_.extend(start, {title: 'Start', icon: '/images/icons/start.png'}),
  _.extend(stop, {title: 'Stop', icon: '/images/icons/finish.png'})].forEach (point) ->
    new google.maps.Marker _.extend(point, {map: map})
    bounds.extend new google.maps.LatLng(point.position.lat, point.position.lng)
  map.fitBounds bounds

  clusterers = []
  ['red', 'blue'].forEach (color) ->
   clusterers[color] = createPathClusterer("icons/#{color}-circle") map

  searchArgs =
    recordTime:
      $gte: start.time
      $lte: stop.time
    deviceId: deviceId
    type: $ne: 35
  Meteor.subscribe 'logbook', searchArgs, ->
    path = Logbook.find(searchArgs, {sort: recordTime: -1}).map (point) ->
      color = 'red' if point.speed >= Settings.maxSpeed
      color = 'blue' if point.speed <= 0.05
      if color
        opts =
          position: new google.maps.LatLng(point.lat, point.lon)
          icon: "/images/icons/#{color}-circle1.png"
          map: map
        info =
          speed: point.speed
          distance: point.distance
        clusterers[color].addMarker(new InfoMarker opts, info, map)

      lat: point.lat, lng: point.lon, id: point._id

    new FleetrPolyline map, path
