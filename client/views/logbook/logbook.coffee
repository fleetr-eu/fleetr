Template.logbook.created = ->
  Meteor.subscribe 'logbook'

Template.logbook.helpers
  mysettings: () ->
   collection: Logbook
   rowsPerPage: 15
   fields: ['type', 'lat', 'lon', 'speed', 'course']
