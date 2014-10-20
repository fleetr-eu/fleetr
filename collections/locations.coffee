@Locations = new Mongo.Collection 'locations'

Locations.before.insert (userId, doc) -> doc.timestamp ?= Date.now()
