Meteor.methods
  submitDriver: (doc) ->
    @unblock()
    Drivers.insert doc

  removeDriver: (doc) ->
    @unblock()
    Drivers.remove _id: doc
