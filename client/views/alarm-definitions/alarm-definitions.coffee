Meteor.subscribe 'alarm-definitions'

Template.alarmDefinitionsList.helpers
  opts: ->
   collection: AlarmDefinitions
   rowsPerPage: 15
   # fields: [
   #   { key: 'time', label: 'Time', fn: (val,obj) -> moment(val).format('DD/MM/YYYY HH:mm:ss') }
   #   { key: 'type', label: 'Type' }
   #   { key: 'lat', label: 'Latitude' }
   #   { key: 'lon', label: 'Longitude' }
   #   { key: 'speed', label: 'Speed' }
   #   { key: 'course', label: 'Course' }
   # ]
   showColumnToggles: true
   class: "table table-bordered table-hover"


Template.alarmDefinitionsList.events
  'click #addAlarmDefinition': (event) ->
    console.log 'ADD'

