Template.maintenanceType.helpers
  maintenanceType: ->
    mt = MaintenanceTypes.findOne _id: @maintenanceTypeId

Template.maintenanceType.events
  "click .btn-sm" : (e) ->
    $("#maintenanceTypeForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintenanceTypeForm")
