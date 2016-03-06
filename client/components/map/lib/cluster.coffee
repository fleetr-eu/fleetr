Meteor.startup ->
  class @FleetrClusterer extends MarkerClusterer
    constructor: (@map) ->
      super @map, [],
        calculator: (markers, styles) ->
          index: 1
          text: markers.length
          title: "Click to expand the cluster."
        zoomOnClick:true
        averageCenter:true
        zIndex: 90
        gridSize:40
        styles: [
          {
            url: "/images/truck-blue.png"
            width: 32
            height: 37
            textSize: 20
            textColor: 'red'
          }
        ]

    removeMarker: (id) ->
      marker = _.find @getMarkers(), (m) -> m.id is id
      super marker

    removeAllMarkers: ->
      @clearMarkers() if @getMarkers()?.length
