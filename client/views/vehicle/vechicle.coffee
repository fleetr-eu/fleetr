Template.vehicle.helpers
  vehicleSchema: -> Schema.vehicle
  vehicle: -> Vehicles.findOne _id: @vehicleId

Template.vehicle.events
  "click .btn-sm" : (e) ->
    $("#vehicleForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("vehicleForm")
