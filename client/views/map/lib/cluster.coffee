Meteor.startup ->
  @createVehicleClusterer = (map) ->
    new MarkerClusterer map, [],
      calculator: (markers, styles) ->
        index: 1
        text: markers.length
        # text: "<img src='/images/truck-red.png'>#{markers.length}</img>"
        # text: "<h1 style='color:red;'>#{markers.length}</h1>"
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
