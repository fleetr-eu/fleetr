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
  formatedMoment: -> moment(@moment).locale(Settings.locale).format(Settings.longDateTimeFormat)
  formatedEvent: ->
    if @event == 'begin'
      "асоцииране"
    else
      "деасоцииране"
  styleEvent: ->
    if @event == 'begin'
      "color:navy;"
    else
      "color:red;"

Template.driverVehicleAssignmentTableRow.events
  'click tr': -> Session.set 'selectedDriverVehicleAssignmentId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#driverVehicleAssignmentFilter #filter').val(tag)
    Session.set 'driverVehicleAssignmentFilter', tag
