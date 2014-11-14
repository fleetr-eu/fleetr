Meteor.startup ->
  Locations._ensureIndex { loc : "2d" }

  unless VehiclesMakes.find().count()
    vi = Assets.getText 'vehicles.json'
    JSON.parse(vi).makes.forEach (make) ->
      makeId = VehiclesMakes.insert _.pick(make, 'name')
      make.models.forEach (model) ->
        doc = makeId:makeId, name:model.name, years:model.years
        VehiclesModels.insert doc

Locations.findLastForVehicleId = (vehicleId) ->
  Locations.findOne {_id: vehicleId}, {sort: {timestamp: -1}}
