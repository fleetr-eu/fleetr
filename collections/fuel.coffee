@ExpensesFuel = new Mongo.Collection 'expensesFuel'

ExpensesFuel.attachSchema Schema.expensesFuel

ExpensesFuel.allow
  insert: -> true