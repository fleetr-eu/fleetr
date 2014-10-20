@Fleets = new Mongo.Collection 'fleets'

Fleets.attachSchema Schema.fleet

Fleets.allow
  insert: -> true
