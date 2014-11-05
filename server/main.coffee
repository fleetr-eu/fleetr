Meteor.startup -> Locations._ensureIndex { loc : "2d" }

Locations.findLastForVehicleId = (vehicleId) ->
  Locations.findOne {_id: vehicleId}, {sort: {timestamp: -1}}
