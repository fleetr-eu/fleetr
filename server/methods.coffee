Meteor.methods
  submitDriver: (doc) ->
    @unblock()
    Drivers.insert doc
