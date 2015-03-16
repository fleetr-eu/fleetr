Meteor.startup ->
  class @FleetrPolyline extends google.maps.Polyline
    constructor: (@map, path) ->
      super
        icons: [
          icon:
            path: google.maps.SymbolPath.BACKWARD_OPEN_ARROW
            strokeWeight: 2
            strokeColor: 'white'
            scale: 1
          offset: '100px'
          repeat: '100px'
        ]
        map: @map
        path: path
        strokeColor: 'blue'
        strokeOpacity: 0.6
        strokeWeight: 7

    addListener: (event, handler) ->
      google.maps.event.addListener @, event, handler

    findNearestPoint: (latlng)->
      needle =
        minDistance: 9999999999
        index: -1
        latlng: null

      @getPath().forEach (routePoint, index) ->
        dist = google.maps.geometry.spherical.computeDistanceBetween(latlng, routePoint)
        if dist < needle.minDistance
          needle.minDistance = dist
          needle.index = index
          needle.latlng = routePoint

      latLng: @getPath().getAt(needle.index), index: needle.index
