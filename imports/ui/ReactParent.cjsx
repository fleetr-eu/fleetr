React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

module.exports = ReactParent = React.createClass
  displayName: 'ReactParent'

  render: ->
    <span>{@props.child}</span>
