Template.driverVehicleAssignments.created = ->Session.setDefault 'driverVehicleAssignmentFilter', ''

Template.driverVehicleAssignments.events
  'click .deleteDriverVehicleAssignment': ->
    Meteor.call 'removeDriverVehicleAssignment', Session.get('selectedDriverVehicleAssignmentId')
    Session.set 'selectedDriverVehicleAssignmentId', null

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
  beginTime: -> moment(@beginAssignmentTime).locale(Settings.locale).format(Settings.longDateTimeFormat)
  endTime: -> moment(@endAssignmentTime).locale(Settings.locale).format(Settings.longDateTimeFormat)

Template.driverVehicleAssignmentTableRow.events
  'click tr': -> Session.set 'selectedDriverVehicleAssignmentId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#driverVehicleAssignmentFilter #filter').val(tag)
    Session.set 'driverVehicleAssignmentFilter', tag
