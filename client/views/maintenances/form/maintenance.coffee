Template.maintenance.helpers
  vechileName: ->
    v = Vehicles.findOne _id: @vehicleId
    "#{v?.name} (#{v?.licensePlate})"

Template.maintenance.events
  "click .btn-sm" : (e) ->
    $("#maintenancesForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintenanceForm")
