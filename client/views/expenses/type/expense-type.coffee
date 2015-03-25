Template.expenseType.rendered = ->
  AutoForm.resetForm("expenseTypeForm")

Template.expenseType.events
  "click .btn-sm" : (e) ->
    $("#expenseTypeForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expenseTypeForm")
