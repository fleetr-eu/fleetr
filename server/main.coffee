Meteor.startup ->
  Locations._ensureIndex { loc : "2d" }

  unless VehiclesInfo.find().count()
    vi = Assets.getText 'vehicles.json'
    JSON.parse(vi).makes.forEach (make) -> VehiclesInfo.insert make

Locations.findLastForVehicleId = (vehicleId) ->
  Locations.findOne {_id: vehicleId}, {sort: {timestamp: -1}}
