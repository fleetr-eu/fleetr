Template.maintainanceType.events
  "click .btn-sm" : (e) ->
    $("#maintainanceTypeForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("maintainanceTypeForm")
