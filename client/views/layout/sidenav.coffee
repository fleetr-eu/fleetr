Template.sidenav.onCreated ->
  Meteor.subscribe 'fleetGroups'
  Meteor.subscribe 'fleets'

Template.sidenav.helpers
  pathForAdminBoard: -> AdminDashboard.path('/')
  fleetGroups: ->
    FleetGroups.find {},
      transform: (fg) ->
        _.extend fg,
          fleets: -> Fleets.find parent: fg._id

Template.sidenav.events
  'click .show-all-vehicles': ->
    Session.set 'vehiclesFleetName', null
  'click .show-fleet-vehicles': ->
    Session.set 'vehiclesFleetName', @name
