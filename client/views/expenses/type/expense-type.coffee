Template.expenseType.rendered = ->
  AutoForm.getValidationContext("expenseTypeForm").resetValidation()

Template.expenseType.events
  "click .btn-sm" : (e) ->
    $("#expenseTypeForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expenseTypeForm")
