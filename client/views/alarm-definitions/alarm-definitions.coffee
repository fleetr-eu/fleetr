Meteor.subscribe 'alarm-definitions'

Template.alarmDefinitionsList.helpers
  opts: ->
   collection: AlarmDefinitions
   rowsPerPage: 15
   showColumnToggles: true
   class: "table table-bordered table-hover"

Template.addAlarmDefModal.events
  'shown.bs.modal': -> $('#addAlarmDef').focus()
