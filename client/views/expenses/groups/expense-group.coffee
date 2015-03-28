Template.expenseGroup.rendered = ->
  AutoForm.getValidationContext("expenseGroupForm").resetValidation()

Template.expenseGroup.events
  "click .btn-sm" : (e) ->
    $("#expenseGroupForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expenseGroupForm")
