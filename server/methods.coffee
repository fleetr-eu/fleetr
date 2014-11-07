Meteor.methods
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

  submitCompany: (doc, diff) -> Companies.submit(doc, diff)

  removeCompany: (doc) -> Companies.remove _id : doc

  addLocation: (doc) -> Locations.insert doc

  submitFleet: (doc, diff) -> Fleets.submit(doc, diff)

  removeFleet: (doc) -> Fleets.remove _id : doc

  submitExpensesFuel: (doc) -> ExpensesFuel.insert doc

  removeExpensesFuel: (doc) -> ExpensesFuel.remove _id : doc

  toggleNotificationSeen: (id, oldSeenState) ->
    newSeenState = !oldSeenState
    Notifications.update {_id: id}, {$set: {seen: newSeenState}}

  removeLocation: (locationId) -> Locations.remove _id: locationId

  reset: () ->
    @unblock()
    Locations.remove {}
    Notifications.remove {}
    Drivers.find().forEach( (doc)->
      Drivers.utils.processNotifications(doc, doc._id)
    )
