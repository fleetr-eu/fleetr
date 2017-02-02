Template.sidenav.onCreated ->
  Meteor.subscribe 'fleetGroups'
  Meteor.subscribe 'fleets'

Template.sidenav.helpers
  fleetGroups: -> FleetGroups.find()

Template.sidenav.events
  'click .show-all-vehicles': ->
    Session.set 'vehiclesFleetName', null
  'click .show-fleet-vehicles': ->
    Session.set 'vehiclesFleetName', @name
