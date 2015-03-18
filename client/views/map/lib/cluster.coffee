Meteor.startup ->
  commonOptions =
    zoomOnClick:true
    averageCenter:true
    gridSize:40

  @createPathClusterer = (imagePrefix) -> (map) ->
    opts = _.extend commonOptions,
      zIndex: 20
      imagePath: "/images/#{imagePrefix}"
      calculator: -> {index: 1, text: ''}
    new MarkerClusterer map, [], opts

  @createSpeedClusterer = createPathClusterer 'speed/m'

  @createStayClusterer = createPathClusterer 'stay/m'

  @createVehicleClusterer = (map) ->
    new MarkerClusterer map, [], _.extend(commonOptions, {zIndex: 90})
