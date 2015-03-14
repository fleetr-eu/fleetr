Template.simpleMap.rendered = ->
  data =  EJSON.parse decodeURIComponent @data
  map = new google.maps.Map document.getElementById("simpleMap"), _.extend(Map.options, {center: data.stop.position})
  [data.start, data.stop].forEach (point) ->
    console.log point
    new google.maps.Marker _.extend(point, {map: map})
