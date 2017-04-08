@FleetGroups = new Mongo.Collection 'fleetGroups'
FleetGroups.attachSchema Schema.fleetGroups

addVehicles = (sum, fleet) -> sum + fleet.vehicleCount()

FleetGroups.helpers
  fleets:  -> Fleets.find parent: @_id
  fleetCount: -> @fleets().count()
  vehicleCount: -> @fleets().fetch().reduce addVehicles, 0
