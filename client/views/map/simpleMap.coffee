Template.simpleMap.rendered = ->
  data =  EJSON.parse decodeURIComponent @data
  map = new google.maps.Map document.getElementById("simpleMap"), _.extend(Map.options, {center: data.stop.position})
  bounds = new google.maps.LatLngBounds()
  [data.start, data.stop].forEach (point) ->
    new google.maps.Marker _.extend(point, {map: map})
    bounds.extend new google.maps.LatLng(point.position.lat, point.position.lng)
  map.fitBounds bounds
