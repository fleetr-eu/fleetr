Meteor.methods
  addGeofence: (doc) -> Geofences.insert doc

  removeGeofence: (gfId) -> Geofences.remove _id: gfId

  submitDriver: (doc, diff) ->
    @unblock()
    # after.insert is not triggered. revome after issues is fixed: https://github.com/matb33/meteor-collection-hooks/issues/16
    if Drivers.find({_id: doc._id}, {limit: 1}).count()
      Drivers.submit doc, diff
    else
      Drivers.insert doc

  removeDriver: (doc) -> Drivers.remove _id: doc

  submitVehicle: (doc, diff) -> Vehicles.submit(doc, diff)

  removeVehicle: (doc) -> Vehicles.remove _id : doc

  submitFleetGroup: (doc, diff) -> FleetGroups.submit(doc, diff)

  removeFleetGroup: (doc) -> FleetGroups.remove _id : doc

  addLocation: (doc) -> Locations.insert doc

  submitFleet: (doc, diff) -> Fleets.submit(doc, diff)

  removeFleet: (doc) -> Fleets.remove _id : doc

  submitExpenses: (doc, diff) ->
    @unblock()
    # after.insert is not triggered. revome after issues is fixed: https://github.com/matb33/meteor-collection-hooks/issues/16
    if Expenses.find({_id: doc._id}, {limit: 1}).count()
      Expenses.submit doc, diff
    else
      Expenses.insert doc

  removeExpenses: (doc) -> Expenses.remove _id : doc

  toggleNotificationSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Notifications.update {_id: id}, {$set: {seen: newSeenState}}

  toggleAlarmSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Alarms.update {_id: id}, {$set: {seen: newSeenState}}

  removeLocation: (locationId) -> Locations.remove _id: locationId

  reset: () ->
    @unblock()
    Locations.remove {}
    Alarms.remove {}
    Notifications.remove {}
    Drivers.find().forEach (doc) ->
      Drivers.utils.processNotifications(doc, doc._id)

  submitDriverVehicleAssignment: (doc, diff) -> DriverVehicleAssignments.submit(doc, diff)

  removeDriverVehicleAssignment: (doc) -> DriverVehicleAssignments.remove _id : doc
