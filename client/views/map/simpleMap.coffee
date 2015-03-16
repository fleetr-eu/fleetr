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
    type: $ne: 35
  Meteor.subscribe 'logbook', searchArgs, ->
    path = Logbook.find(searchArgs, {sort: recordTime: -1}).map (point) ->
      lat: point.lat, lng: point.lon, id: point._id

    poly = new FleetrPolyline map, path
    poly.infoWindows = {}
    poly.addListener 'click', (e) ->
      nearest = @findNearestPoint(e.latLng)
      point = Logbook.findOne _id: path[nearest.index].id
      nearest.loc = [point.lon, point.lat]
      infoWindow = @infoWindows[nearest.index]
      unless infoWindow
        infoWindow = new SimpleInfoWindow point
        infoWindow.marker = new EmptyMarker(nearest, map)
        @infoWindows[nearest.index] = infoWindow
      infoWindow.open map, infoWindow.marker
