Meteor.methods
  getUser: -> Meteor.user()

  submitGeofence: (doc) ->
    if Geofences.findOne(_id: doc._id)
      Geofences.update {_id: doc._id}, {$set: _.omit(doc, '_id')}
    else
      Geofences.insert doc

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

  removeFleetGroup: (gid) ->
    @unblock()
    FleetGroups.remove _id : gid

  addLocation: (doc) ->
    @unblock()
    Locations.insert doc

  submitFleet: (doc, diff) ->
    @unblock()
    Fleets.submit(doc, diff)

  removeFleet: (doc) ->
    @unblock()
    Fleets.remove _id : doc

  submitMaintenanceType: (doc, diff) ->
    @unblock()
    MaintenanceTypes.submit(doc, diff)

  removeMaintenanceType: (doc) ->
    @unblock()
    MaintenanceTypes.remove _id : doc

  submitExpenseGroup: (doc, diff) ->
    @unblock()
    ExpenseGroups.submit(doc, diff)

  submitExpenseType: (doc, diff) ->
    @unblock()
    ExpenseTypes.submit(doc, diff)

  submitExpense: (doc, diff) ->
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

  removeDriverVehicleAssignment: (doc) ->
    DriverVehicleAssignments.remove _id : doc

  # findCachedLocationName: (lat,lon) ->
  #   console.log 'MyCodes: ' + MyCodes.find().count()
  #   doc = MyCodes.findOne {lat: lat, lon: lon}
  #   console.log '  : ' + lat + ':' + lon + ' found: ' + doc
  #   doc


  cacheLocationName: (lat,lon,address) ->
    doc = MyCodes.findOne {lat: lat, lon: lon}
    if doc
      console.log 'Cached: ' + JSON.stringify(doc)
      #MyCodes.update {_id: doc._id}, {$set: {address: address}}
    else
      doc = {lat: lat, lon: lon, address: address}
      console.log 'Insert cache: ' + JSON.stringify(doc)
      MyCodes.insert doc
    doc
