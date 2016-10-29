Meteor.startup ->
  _removeMarker = MarkerClusterer.prototype.removeMarker
  MarkerClusterer.prototype.removeMarker = (id) ->
    marker = _.find @getMarkers(), (m) -> m.id is id
    _removeMarker marker

  MarkerClusterer.prototype.removeAllMarkers = ->
    @clearMarkers() if @getMarkers()?.length

  @FleetrClusterer = (map) ->
    new MarkerClusterer map, [],
      zoomOnClick: true
      averageCenter: true
      zIndex: 90
      gridSize: 40
      imagePath: '/images/cluster/m'
