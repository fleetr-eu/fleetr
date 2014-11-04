Meteor.methods
  submitDriver: (doc) ->
    @unblock()
    # after.insert is not triggered. revome after issues is fixed: https://github.com/matb33/meteor-collection-hooks/issues/16
    if Drivers.findOne {_id: doc._id}
      Drivers.upsert {_id: doc._id}, {$set: _.omit(doc, '_id')}
    else
      Drivers.insert doc

  removeDriver: (doc) ->
    @unblock()
    Drivers.remove _id: doc

  submitVehicle: (doc) ->
    @unblock()
    Vehicles.upsert {_id: doc._id}, {$set: _.omit(doc, '_id')}

  removeVehicle: (doc) ->
    @unblock()
    Vehicles.remove _id : doc

  submitCompany: (doc) ->
    @unblock()
    Companies.upsert {_id: doc._id}, {$set: _.omit(doc, '_id')}

  removeCompany: (doc) ->
    @unblock()
    Companies.remove _id : doc

  addLocation: (doc) ->
    @unblock
    Locations.insert doc

  submitFleet: (doc) ->
    @unblock()
    Fleets.upsert {_id: doc._id}, {$set: _.omit(doc, '_id')}

  removeFleet: (doc) ->
    @unblock()
    Fleets.remove _id : doc

  submitExpensesFuel: (doc) ->
    @unblock()
    ExpensesFuel.insert doc

  removeExpensesFuel: (doc) ->
    @unblock()
    ExpensesFuel.remove _id : doc

  toggleNotificationSeen: (id, oldSeenState) ->
    @unblock()
    newSeenState = !oldSeenState
    Notifications.update {_id: id}, {$set: {seen: newSeenState}}

  removeLocation: (locationId) ->
    @unblock()
    Locations.remove _id: locationId

  reset: () ->
    @unblock()
    Locations.remove {}
    Notifications.remove {}
