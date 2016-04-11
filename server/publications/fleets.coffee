Meteor.publish 'fleetGroups', (filter = {}) ->
  FleetGroups.find filter, {$sort: {name: 1}}
Meteor.publish 'fleetGroup', (gid) -> FleetGroups.find {_id: gid}
Meteor.publish 'fleets', (filter) -> Fleets.find filter or {}
Meteor.publish 'fleetsForVehicleList', ->
  Fleets.find {},
    fields:
      name: 1
Meteor.publish 'fleet', (fid) -> Fleets.find {_id: fid}
