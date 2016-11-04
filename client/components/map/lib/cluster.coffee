Meteor.startup ->
  MarkerClusterer.prototype.removeAllMarkers = ->
    @clearMarkers() if @getMarkers()?.length

  @FleetrClusterer = (map) ->
    new MarkerClusterer map, [],
      zoomOnClick: true
      averageCenter: true
      zIndex: 90
      gridSize: 40
      imagePath: '/images/cluster/m'
