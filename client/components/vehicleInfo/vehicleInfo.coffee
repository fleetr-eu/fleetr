Template.vehicleInfo.onRendered ->
  msg = @data.message
  Meteor.subscribe 'vehicleInfo', @data.unitId

Template.vehicleInfo.helpers
  vehicle: -> Vehicles.findOne()
  fleet: -> Fleets.findOne(_id: @allocatedToFleet)
  fleetGroup: -> FleetGroups.findOne(_id: @parent)
  driver: -> Drivers.findOne(_id: @driver_id)
  stateIcon: ->
    if @state == 'stop'
      'blue'
    else if @state == 'start'
      if @alarms?.speedingAlarmActive &&
        @speed > @alarms?.maxAllowedSpeed
          'red'
      else
        'green'
    else
      'red'
  odometer: -> (@odometer / 1000).toFixed(3)
  toFixed: (field, precision) -> @[field]?.toFixed(precision)
  message: -> Template.instance().data.message
