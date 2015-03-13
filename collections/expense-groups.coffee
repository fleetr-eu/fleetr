@ExpenseGroups = new Mongo.Collection 'expenseGroups'
Partitioner.partitionCollection ExpenseGroups
ExpenseGroups.attachSchema Schema.expenseGroups
