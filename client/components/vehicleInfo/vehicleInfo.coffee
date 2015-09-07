vehicle = new ReactiveVar {}
fleet = new ReactiveVar {}
group = new ReactiveVar {}
driver = new ReactiveVar {}
msg = ''

Template.vehicleInfo.created = ->
  msg = @data.message
  Meteor.subscribe 'vehicleInfo', @data.unitId, =>
    console.log @data.unitId
    v = Vehicles.findOne(unitId: @data.unitId)
    if v
      vehicle.set v
      fleet.set Fleets.findOne(_id: vehicle.get()?.allocatedToFleet)
      group.set FleetGroups.findOne(_id: fleet.get()?.parent)
      assignment = DriverVehicleAssignments.findOne(vehicle: vehicle.get()?._id)
      driver.set Drivers.findOne(_id: assignment?.driver)

Template.vehicleInfo.helpers
  vehicle: -> vehicle.get()
  fleet: -> fleet.get()
  fleetGroup: -> group.get()
  driver: -> driver.get()
  stateIcon: ->
    if vehicle.get().state == 'stop'
      'blue'
    else if vehicle.get().state == 'start'
      if vehicle.get().alarms?.speedingAlarmActive &&
        vehicle.get().speed > vehicle.get().alarms?.maxAllowedSpeed
          'red'
      else
        'green'
    else
      'red'
  odometer: -> (vehicle.get().odometer / 1000).toFixed(3)
  toFixed: (field, precision) -> vehicle.get()[field]?.toFixed(precision)
  message: -> msg
