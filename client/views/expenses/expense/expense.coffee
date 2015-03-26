Template.expense.rendered = ->
  AutoForm.getValidationContext("expensesForm").resetValidation()

Template.expense.events
  "click .btn-sm" : (e) ->
    $("#expensesForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expensesForm")
