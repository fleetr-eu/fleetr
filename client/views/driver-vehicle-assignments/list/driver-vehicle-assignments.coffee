Template.driverVehicleAssignments.created = ->Session.setDefault 'driverVehicleAssignmentFilter', ''

Template.driverVehicleAssignments.helpers
  driverVehicleAssignments: -> DriverVehicleAssignments.find {}
  selectedDriverVehicleAssignmentId: -> Session.get('selectedDriverVehicleAssignmentId')

Template.driverVehicleAssignmentTableRow.helpers
  driverName:->
    foundDriver = Drivers.findOne {_id: @driver}
    if foundDriver
      "#{foundDriver.firstName} #{foundDriver.name}"
    else
      ""
  vehicleLicensePlate:->
    foundVehicle = Vehicles.findOne {_id: @vehicle}
    if foundVehicle
      foundVehicle.licensePlate
    else
      ""
  active: -> if @_id == Session.get('selectedDriverVehicleAssignmentId') then 'active' else ''
  formatedDate: -> moment(@moment).locale(Settings.locale).format(Settings.longDateFormat)
  formatedEvent: ->
    if @event == 'begin'
      "associate"
    else
      "disassociate"
  styleEvent: ->
    if @event == 'begin'
      "color:navy;"
    else
      "color:red;"

Template.driverVehicleAssignmentTableRow.events
  'click tr': -> Session.set 'selectedDriverVehicleAssignmentId', @_id
