Meteor.subscribe('logbook')

columns = ['type', 'lat', 'lon', 'speed', 'course']

settings = {
	collection: Logbook, rowsPerPage: 15, fields: columns
}

Template.logbook.helpers({
    collection: () ->  Logbook
	mysettings: () -> settings
});