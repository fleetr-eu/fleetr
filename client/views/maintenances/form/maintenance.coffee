Template.maintenance.helpers
  licensePlate: ->
    vehicle = Vehicles.findOne _id: @vehicleId
    vehicle?.licensePlate

Template.maintenance.events
  "click .btn-sm" : (e) ->
    $("#maintenancesForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintenanceForm")
