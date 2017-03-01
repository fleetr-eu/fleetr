Template.sidenav.onCreated ->
  Meteor.subscribe 'fleetGroups'
  Meteor.subscribe 'fleets'
  Meteor.subscribe 'vehicles/names'

Template.sidenav.helpers
  fleetGroups: -> FleetGroups.find()
  allVehiclesCount: -> Vehicles.find().count()
  movingVehiclesCount: -> Vehicles.find(state: "start").count()

Template.sidenav.events
  'click .show-all-vehicles': ->
    Session.set 'vehiclesFleetName', null
  'click .show-fleet-vehicles': ->
    Session.set 'vehiclesFleetName', @name
