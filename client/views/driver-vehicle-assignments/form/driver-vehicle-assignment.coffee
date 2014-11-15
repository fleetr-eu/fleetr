Template.driverVehicleAssignment.helpers
  driverVehicleAssignmentsSchema: -> Schema.driverVehicleAssignments
  driverVehicleAssignment: -> DriverVehicleAssignments.findOne _id: @driverVehicleAssignmentId

Template.driverVehicleAssignment.events
  "click .btn-sm" : (e) ->
    $("#driverVehicleAssignmentForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("driverVehicleAssignmentForm")
