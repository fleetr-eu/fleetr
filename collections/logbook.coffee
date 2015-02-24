#Creates a Collection object and generates test data for it.
#Runs before main.coffee
@Logbook = new Meteor.Collection "logbook"
# N = 1000
# if Meteor.isServer and @Logbook.find().count() isnt N
#   Logbook.remove {}
#   Logbook._ensureIndex id: 1
#   for i in [1 .. N]
#     Logbook.insert
#       id: i
#       group: Math.round Math.random()