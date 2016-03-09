Meteor.startup ->
  class @FleetrClusterer extends MarkerClusterer
    constructor: (@map) ->
      super @map, [],
        zoomOnClick:true
        averageCenter:true
        zIndex: 90
        gridSize:40

    removeMarker: (id) ->
      marker = _.find @getMarkers(), (m) -> m.id is id
      super marker

    removeAllMarkers: ->
      @clearMarkers() if @getMarkers()?.length
