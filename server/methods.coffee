Meteor.methods
  getUser: -> Meteor.user()

  addGeofence: (doc) -> Geofences.insert doc

  removeGeofence: (gfId) -> Geofences.remove _id: gfId

  submitDriver: (doc, diff) ->
    @unblock()
    Drivers.submit doc, diff

  removeDriver: (doc) ->
    @unblock()
    Drivers.remove _id: doc

  submitVehicle: (doc, diff) ->
    @unblock()
    Vehicles.submit(doc, diff)

  removeVehicle: (doc) ->
    @unblock()
    Vehicles.remove _id : doc

  submitFleetGroup: (doc, diff) ->
    @unblock()
    FleetGroups.submit(doc, diff)

  removeFleetGroup: (doc) ->
    @unblock()
    FleetGroups.remove _id : doc

  addLocation: (doc) ->
    @unblock()
    Locations.insert doc

  submitFleet: (doc, diff) ->
    @unblock()
    Fleets.submit(doc, diff)

  removeFleet: (doc) ->
    @unblock()
    Fleets.remove _id : doc

  submitExpenses: (doc, diff) ->
    @unblock()
    Expenses.submit doc, diff

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
