@Locations = new Mongo.Collection 'locations'

Locations.before.insert (userId, doc) -> doc.timestamp ?= Date.now()

Locations.findForVehicles = (vehicleIds) ->
    Locations.find {vehicleId: {$in: vehicleIds}}, {sort: {timestamp: -1}}
