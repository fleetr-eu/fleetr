Template.expensesFuel.helpers
  expensesFuel: -> Expenses.findOne _id: @expenseId

Template.expensesFuel.events
  "click .btn-sm" : (e) ->
    $("#expensesFuelForm").submit()
  "click .btn-reset" : (e) ->
    AutoForm.resetForm("expensesFuelForm")

AutoForm.hooks
  expensesFuelForm:
    onSubmit: (insertDoc, updateDoc, currentDoc) ->
      @event.preventDefault()
      insertDoc.expenseType = "fuel"
      Meteor.call 'submitExpenses', insertDoc, updateDoc
      @resetForm()
      @done()
    onError: (operation, error, template) ->
      Meteor.defer ->
        id = template.$('.has-error').closest('div.tab-pane').attr('id')
        template.$("a[href=##{id}]").tab('show')
