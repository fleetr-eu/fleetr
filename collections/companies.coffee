@Companies = new Mongo.Collection 'companies'

Companies.attachSchema Schema.company

Companies.allow
  insert: -> true
