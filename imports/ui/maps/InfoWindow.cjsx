React           = require 'react'
ReactDOMServer  = require 'react-dom/server'
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'InfoWindow'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (@props.marker isnt prevProps.marker)
      @renderInfoWindow()
    if @props.children isnt prevProps.children
      @updateContent

  updateContent: ->
    @infoWindow?.setContent @renderChildren()

  renderChildren: ->
    if typeof @props.children is 'string'
      "#{@props.children}"
    else ReactDOMServer.renderToString @props.children

  renderInfoWindow: ->
    {marker, google, map} = @props
    @infoWindow = new google.maps.InfoWindow content: ''
    installListeners @, @infoWindow
    @updateContent()
    marker?.addListener 'click', (evt) =>
      @infoWindow.open map, marker

  render: -> null
