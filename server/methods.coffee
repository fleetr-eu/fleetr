Meteor.methods
  submitDriver: (doc) ->
    @unblock()
    Drivers.insert doc

  removeDriver: (doc) ->
    @unblock()
    Drivers.remove _id: doc

  submitVehicle: (doc) ->
    @unblock()
    Vehicles.insert doc

  removeVehicle: (doc) ->
    @unblock()
    Vehicles.remove _id : doc

  submitCompany: (doc) ->
    @unblock()
    Companies.insert doc

  removeCompany: (doc) ->
    @unblock()
    Companies.remove _id : doc

  addLocation: (doc) ->
    @unblock
    Locations.insert doc

  submitFleet: (doc) ->
    @unblock()
    Fleets.insert doc

  removeFleet: (doc) ->
    @unblock()
    Fleets.remove _id : doc

  submitExpensesFuel: (doc) ->
    @unblock()
    ExpensesFuel.insert doc

  removeExpensesFuel: (doc) ->
    @unblock()
    ExpensesFuel.remove _id : doc
