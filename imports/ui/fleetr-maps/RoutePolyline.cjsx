React    = require 'react'
Polyline = require '../maps/Polyline.cjsx'

module.exports  = React.createClass
  displayName: 'RoutePolyline'

  getOptions: (path, isSelected)->
    options =
      icons: [
        icon:
          path: google.maps.SymbolPath.FORWARD_OPEN_ARROW
          strokeWeight: 2
          strokeColor: 'white'
          scale: 1
        offset: '30px'
        repeat: '30px'
      ]
      strokeColor: if isSelected
        if path[0].speeding then 'red' else 'blue'
      else 'gray'
      strokeOpacity: 0.6
      strokeWeight: 7

  render: ->
    paths = []

    if @props.selected
      path = []

      x = @props.points.map (p) -> p.speeding = p.speed > 100; p

      bounds = new google.maps.LatLngBounds()

      for point in x
        bounds.extend(new google.maps.LatLng point.lat, point.lng)
        if path.length is 0
          path.push point
        else
          [..., l] = path
          if l.speeding is point.speeding
            path.push point
          else
            path.push point
            paths.push path
            path = []
            path.push point

      if path.length then paths.push path
    else paths.push @props.points

    # @props.map?.fitBounds bounds if @props.selected

    <span>
    {paths.map (path, i) =>
      <Polyline key={i} options={@getOptions(path, @props.selected)} path={path} {...@props} />
    }
    </span>
