Meteor.subscribe 'drivers'
Meteor.subscribe 'companies'
Meteor.subscribe 'fleets'
Meteor.subscribe 'vehicles'
Meteor.subscribe 'countries'

Session.setDefault 'driverFilter', ''
Session.setDefault 'vehicleFilter', ''
Session.setDefault 'companyFilter', ''