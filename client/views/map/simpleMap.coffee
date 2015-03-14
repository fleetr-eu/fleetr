Template.simpleMap.rendered = ->
  data =  EJSON.parse decodeURIComponent @data
  map = new google.maps.Map document.getElementById("simpleMap"), Map.options
  bounds = new google.maps.LatLngBounds()
  [data.start, data.stop].forEach (point) ->
    new google.maps.Marker _.extend(point, {map: map})
    bounds.extend new google.maps.LatLng(point.position.lat, point.position.lng)
  map.fitBounds bounds

  Meteor.subscribe 'logbook', {recordTime: { $gte: data.start.time, $lte: data.stop.time }, deviceId: data.deviceId}, ->
    path = Logbook.find({}, {sort: recordTime: -1}).map (point) ->
      lat: point.lat, lng: point.lon

    line = new google.maps.Polyline
      icons: [
        icon:
          path: google.maps.SymbolPath.BACKWARD_OPEN_ARROW
          strokeWeight: 2
          strokeColor: 'white'
          scale: 1
        offset: '100px'
        repeat: '100px'
      ]
      map: map
      path: path
      strokeColor: 'blue'
      strokeOpacity: 0.6
      strokeWeight: 7
