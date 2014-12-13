@Expenses = new Mongo.Collection 'expenses'
Partitioner.partitionCollection Expenses
Expenses.attachSchema Schema.expenses

Expenses.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()
