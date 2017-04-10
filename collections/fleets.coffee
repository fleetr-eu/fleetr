@Fleets = new Mongo.Collection 'fleets'
Fleets.attachSchema Schema.fleet

Fleets.helpers
  vehicleCount: ->
    Vehicles.find(allocatedToFleet: @_id).count()
