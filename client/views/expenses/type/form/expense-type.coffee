Template.expenseType.rendered = ->
  AutoForm.getValidationContext("expenseTypeForm").resetValidation()

Template.expenseType.helpers
  expenseType: -> ExpenseTypes.findOne _id: @expenseTypeId

Template.expenseType.events
  "click .submit" : (e) ->
    $("#expenseTypeForm").submit()
  "click .reset" : (e) ->
    AutoForm.resetForm("expenseTypeForm")
