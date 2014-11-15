Meteor.subscribe 'drivers'
Meteor.subscribe 'fleetGroups'
Meteor.subscribe 'fleets'
Meteor.subscribe 'vehicles'
Meteor.subscribe 'countries'
# Meteor.subscribe 'locations'
Meteor.subscribe 'expenses'
Meteor.subscribe 'notifications'
Meteor.subscribe 'alarms'
Meteor.subscribe 'driverVehicleAssignments'
Meteor.subscribe 'vehiclesMakes'
Meteor.subscribe 'vehiclesModels'

Session.setDefault 'filterAlarms', ''
Session.setDefault 'filterNotifications', ''
Session.setDefault 'showSeenNotifications', false
Session.setDefault 'filterFleets', ''
Session.setDefault 'filterVehicles', ''
Session.setDefault 'filterDrivers', ''
Session.setDefault 'activeCategory', 'dashboard'
