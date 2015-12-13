Meteor.startup ->
  Vehicles._ensureIndex
    loc: '2dsphere'
