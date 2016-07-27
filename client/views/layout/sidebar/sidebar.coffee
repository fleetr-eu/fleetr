Template.sidebar.onCreated ->
  Meteor.subscribe 'fleetGroups'
  Meteor.subscribe 'fleets'

Template.sidebar.helpers
  pathForAdminBoard: -> AdminDashboard.path('/')
  fleetGroups: ->
    FleetGroups.find {},
      transform: (fg) ->
        _.extend fg,
          fleets: -> Fleets.find parent: fg._id

Template.sidebar.events
  'click .show-all-vehicles': ->
    Session.set 'vehiclesFleetName', null
  'click .show-fleet-vehicles': ->
    Session.set 'vehiclesFleetName', @name
