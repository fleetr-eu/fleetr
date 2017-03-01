@Fleets = new Mongo.Collection 'fleets'
Partitioner.partitionCollection Fleets
Fleets.attachSchema Schema.fleet

Fleets.helpers
  vehicleCount: ->
    Vehicles.find(allocatedToFleet: @_id).count()
