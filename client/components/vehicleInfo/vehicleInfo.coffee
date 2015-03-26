vehicle = null
fleet = null
group = null
driver = null
msg = ''

Template.vehicleInfo.created = ->
  Meteor.subscribe 'vehicleInfo', @data?.unitId

  msg = @data.message
  vehicle = Vehicles.findOne(unitId: @data?.unitId)
  fleet = Fleets.findOne(_id: vehicle?.allocatedToFleet)
  group = FleetGroups.findOne(_id: fleet?.parent)
  assignment = DriverVehicleAssignments.findOne(vehicle: vehicle?._id)
  driver = Drivers.findOne(_id: assignment?.driver)

Template.vehicleInfo.helpers
  vehicle: -> vehicle
  fleet: -> fleet.name
  fleetGroup: -> group.name
  driver: -> "#{driver.firstName} #{driver.name}"
  stateIcon: ->
    state = 'red'
    if vehicle.state == 'stop'
      state = 'blue'
    if vehicle.state == 'start'
      if vehicle.alarms.speedingAlarmActive &&
        vehicle.speed > vehicle.alarms.maxAllowedSpeed
          state = 'red'
      else
        state = green
  toFixed: (field, precision) -> vehicle[field].toFixed(precision)
  message: -> msg
