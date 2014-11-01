Meteor.methods
  submitDriver: (doc) ->
    @unblock()
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
