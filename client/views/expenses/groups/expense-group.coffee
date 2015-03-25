Template.expenseGroup.rendered = ->
  AutoForm.resetForm("expenseGroupForm")
  
Template.expenseGroup.events
  "click .btn-sm" : (e) ->
    $("#expenseGroupForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expenseGroupForm")
