#Creates a Collection object and generates test data for it.
#Runs before main.coffee
@Items = new Meteor.Collection "logbook"
N = 1000
if Meteor.isServer and @Items.find().count() isnt N
  Items.remove {}
  Items._ensureIndex id: 1
  for i in [1 .. N]
    Items.insert
      id: i
      group: Math.round Math.random()