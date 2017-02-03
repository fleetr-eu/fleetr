@FleetGroups = new Mongo.Collection 'fleetGroups'
Partitioner.partitionCollection FleetGroups
FleetGroups.attachSchema Schema.fleetGroups

addVehicles = (sum, fleet) -> sum + fleet.vehicleCount()

FleetGroups.helpers
  fleets: -> Fleets.find parent: @_id
  fleetCount: -> Fleets.find(parent: @_id).count()
  vehicleCount: -> @fleets().fetch().reduce addVehicles, 0
