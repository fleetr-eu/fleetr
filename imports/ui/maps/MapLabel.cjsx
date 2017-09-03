React   = require 'react'
equal   = require('deep-equal')
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'MapLabel'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (not equal(@props.position, prevProps.position))
      @renderMarker()

  componentWillMount: ->
    if @props.map? and @props.position? then @renderMarker()

  componentWillUnmount: ->
    @state?.label?.setMap null

  renderMarker: ->
    if @state?.label then @state.label.setMap null # remove existing marker, if any
    {position, google, map} = @props
    pos = position or mapCenter

    mapLabel = new MapLabel
      text: @props.label
      position: new google.maps.LatLng pos.lat, pos.lng
      map: map
      fontSize: 18
      zIndex: 9999999
      strokeWeight: 10
      fontColor: '#FFFFFF'
      strokeColor: '#3F3F3F'
      align: 'center'

    installListeners @, mapLabel
    @setState mapLabel: mapLabel


  render: ->
    <span />
