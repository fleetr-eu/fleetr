Meteor.startup ->
  commonOptions =
    zoomOnClick:true
    averageCenter:true
    gridSize:40

  @createSpeedClusterer = (map) ->
      opts = _.extend commonOptions,
        zIndex: 20
        imagePath: '/images/m'
        calculator: -> {index: 1, text: ''}
      new MarkerClusterer map, [], opts


  @createVehicleClusterer = (map) ->
      new MarkerClusterer map, [], _.extend(commonOptions, {zIndex: 90})
