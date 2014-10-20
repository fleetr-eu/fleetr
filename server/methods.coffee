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