@ExpenseTypes = new Mongo.Collection 'expenseTypes'
Partitioner.partitionCollection ExpenseTypes
ExpenseTypes.attachSchema Schema.expenseTypes
