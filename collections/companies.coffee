@Companies = new Mongo.Collection 'companies'

Companies.attachSchema Schema.company
