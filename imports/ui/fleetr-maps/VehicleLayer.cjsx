React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'
VehicleMarker       = require './VehicleMarker.cjsx'

VehicleLayer = React.createClass
  displayName: 'VehicleLayer'

  render: ->
    <span>
      {@props.vehicles.map (v) => <VehicleMarker key={v._id} vehicle={v} {...@props} /> }\
    </span>

module.exports = createContainer (props) ->
  vehicles = Vehicles.find {},
    fields:
      state: 1
      name: 1
      lat: 1
      lng: 1
      speed: 1
      odometer: 1
      licensePlate: 1
      course: 1
      courseCorrection: 1
      driver_id: 1
      tripTime: 1
      idleTime: 1
      restTime: 1

  vehicles: vehicles.fetch()
, VehicleLayer
