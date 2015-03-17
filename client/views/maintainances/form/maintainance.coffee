Template.maintainance.rendered
  vehicle: -> Vehicles.findOne _id: @vehicleId

Template.maintainance.events
  "click .btn-sm" : (e) ->
    $("#maintainancesForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintainanceForm")
