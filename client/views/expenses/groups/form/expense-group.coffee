Template.expenseGroup.rendered = ->
  AutoForm.getValidationContext("expenseGroupForm").resetValidation()

Template.expenseGroup.helpers
  expenseGroup: -> ExpenseGroups.findOne _id: @expenseGroupId

Template.expenseGroup.events
  "click .submit" : (e) ->
    $("#expenseGroupForm").submit()
  "click .reset" : (e) ->
    AutoForm.resetForm("expenseGroupForm")
