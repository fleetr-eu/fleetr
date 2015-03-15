Template.simpleMap.rendered = ->
  {deviceId, start, stop} =  EJSON.parse decodeURIComponent @data
  map = new google.maps.Map document.getElementById("simpleMap"), Map.options
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
  Meteor.subscribe 'logbook', searchArgs, ->
    path = Logbook.find(searchArgs, {sort: recordTime: -1}).map (point) ->
      lat: point.lat, lng: point.lon

    new FleetrPolyline map, path
