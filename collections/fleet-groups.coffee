@FleetGroups = new Mongo.Collection 'fleetGroups'
Partitioner.partitionCollection FleetGroups
FleetGroups.attachSchema Schema.fleetGroups

FleetGroups.helpers
  fleets: -> Fleets.find parent: @_id
  fleetCount: -> Fleets.find(parent: @_id).count()
