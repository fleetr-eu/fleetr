@Expenses = new Mongo.Collection 'expenses'

Expenses.attachSchema Schema.expenses

Expenses.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()
