Meteor.subscribe 'drivers'
Meteor.subscribe 'fleets'
Meteor.subscribe 'vehicles'
Meteor.subscribe 'countries'

Session.setDefault 'driverFilter', ''
Session.setDefault 'vehicleFilter', ''
