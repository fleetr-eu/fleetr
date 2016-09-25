@Expenses = new Mongo.Collection 'expenses'
Partitioner.partitionCollection Expenses
# Expenses.attachSchema Schema.expenses

Expenses.allow
  insert: (userId, doc) ->
    userId

Expenses.before.insert (userId, doc) ->
  doc.timestamp ?= Date.now()
